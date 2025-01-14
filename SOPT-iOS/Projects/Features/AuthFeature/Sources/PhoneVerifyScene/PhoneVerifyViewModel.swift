//
//  SignUpPhoneVerifiyViewModel.swift
//  AuthFeature
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import AuthFeatureInterface
import Domain
import Core

public class PhoneVerifyViewModel: PhoneVerifyViewModelType {

    private let useCase: PhoneVerifyUseCase
    
    private let timerPublisher: Timer.TimerPublisher
    @Published private var timerCancellable: AnyCancellable?
    
    // MARK: - Inputs
    
    public struct Input {
        let sendButtonTapped: Driver<Void>
        let doneButtonTapped: Driver<Void>
        let phoneTextFieldText: Driver<String>
        let codeTextFieldText: Driver<String>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let isSent = CurrentValueSubject<Bool, Never>(false)
        let verifySuccess = PassthroughSubject<Void, Never>()
        let failDescription = PassthroughSubject<String?, Never>()
        let showToast = PassthroughSubject<String, Never>()
        let timeLeft = PassthroughSubject<Int, Never>()
        let timerIsRunning = PassthroughSubject<Bool, Never>()
        let sendButtonIsEnabled = CurrentValueSubject<Bool, Never>(false)
        let doneButtonIsEnabled =  CurrentValueSubject<Bool, Never>(false)
    }
    
    // MARK: - init
    
    init(
        useCase: PhoneVerifyUseCase,
        timerPublisher: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .default)
    ) {
        self.useCase = useCase
        self.timerPublisher = timerPublisher
    }
}

extension PhoneVerifyViewModel {
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        $timerCancellable
            .map { $0 != nil }
            .subscribe(output.timerIsRunning)
            .store(in: cancelBag)
        
        useCase.sideEffect
            .withUnretained(self)
            .sink { owner, err in
                switch err {
                case .invalidVerifyCode:
                    output.failDescription.send("인증번호가 올바르지 않습니다.")
                    return
                case .timeout:
                    owner.timerCancellable = nil
                    output.failDescription.send("3분이 초과되었어요. 인증번호를 다시 요청해주세요.")
                    return
                }
            }
            .store(in: cancelBag)
        
        input.sendButtonTapped
            .handleEvents(receiveOutput: { _ in
                output.isSent.send(true)
                output.failDescription.send(nil) }
            )
            .withLatestFrom(input.phoneTextFieldText)
            .map { PhoneSendModel(name: nil, phone: $0, type: .register) }
            .flatMap(useCase.send)
            .withUnretained(self)
            .sink { owner , _ in
                output.timeLeft.send(owner.useCase.policy.timeLimit)
                owner.timerCancellable = owner.timerPublisher
                    .autoconnect()
                    .scan(owner.useCase.policy.timeLimit) { counter, _ in counter - 1 }
                    .withUnretained(self)
                    .sink { owner, counter in
                        guard counter >= 0 else {
                            owner.useCase.sideEffect.send(.timeout)
                            return
                        }
                        output.timeLeft.send(counter)
                    }
                output.showToast.send("인증번호가 전송되었어요.")
            }
            .store(in: cancelBag)
        
        input.phoneTextFieldText
            .map { $0.count >= self.useCase.policy.phoneNumberCount && $0.allSatisfy { $0.isNumber } }
            .sink { output.sendButtonIsEnabled.send($0) }
            .store(in: cancelBag)
        
        Publishers.CombineLatest(
            input.codeTextFieldText,
            output.timerIsRunning
        )
        .map { !$0.isEmpty && $1 }
        .sink { output.doneButtonIsEnabled.send($0) }
        .store(in: cancelBag)
        
        input.doneButtonTapped
            .withLatestFrom(output.timerIsRunning)
            .filter { $0 }
            .withLatestFrom(Publishers.Zip(input.phoneTextFieldText, input.codeTextFieldText))
            .map { PhoneVerifyModel(name: nil, phone: $0, code: $1, type: .register)}
            .flatMap(useCase.verify)
            .withUnretained(self)
            .sink { owner, _ in
                owner.timerCancellable = nil
                output.verifySuccess.send(())
            }
            .store(in: cancelBag)
        
        return output
    }

}
