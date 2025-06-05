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
    
    private let phoneVerifyType: PhoneVerifyType
    
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
        let isSent = PassthroughSubject<Bool, Never>()
        let verifySuccess = PassthroughSubject<Void, Never>()
        let phoneFailDescription = PassthroughSubject<String?, Never>()
        let codeFailDescription = PassthroughSubject<String?, Never>()
        let timeLeft = PassthroughSubject<Int, Never>()
        let phoneTextFieldText = CurrentValueSubject<String, Never>("")
        let codeTextFieldText = CurrentValueSubject<String, Never>("")
        let timerIsRunning = PassthroughSubject<Bool, Never>()
        let sendButtonIsEnabled = CurrentValueSubject<Bool, Never>(false)
        let doneButtonIsEnabled =  CurrentValueSubject<Bool, Never>(false)
    }
    
    // MARK: - init
    
    init(
        useCase: PhoneVerifyUseCase,
        phoneVerifyType: PhoneVerifyType,
        timerPublisher: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .default)
    ) {
        self.useCase = useCase
        self.phoneVerifyType = phoneVerifyType
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
                    output.codeFailDescription.send("인증번호가 올바르지 않습니다.")
                    return
                case .timeout:
                    owner.timerCancellable = nil
                    output.codeFailDescription.send("3분이 초과되었어요. 인증번호를 다시 요청해주세요.")
                    return
                case .userNotFound:
                    output.phoneFailDescription.send("SOPT 활동 시 사용한 전화번호가 아니에요.")
                case .alreadyExist:
                    output.phoneFailDescription.send("이미 가입된 전화번호예요.")
                case .unknown(_):
                    output.codeFailDescription.send("알 수 없는 오류예요.")
                }
            }
            .store(in: cancelBag)
        
        input.sendButtonTapped
            .throttle(for: 2, scheduler: RunLoop.main, latest: false)
            .handleEvents(receiveOutput: { _ in
                output.phoneFailDescription.send(nil)
                output.codeFailDescription.send(nil)
            }
            )
            .withUnretained(self)
            .map { owner, _ in 
                PhoneSendModel(
                    name: nil,
                    phone: output.phoneTextFieldText.value,
                    type: owner.phoneVerifyType
            )}
            .flatMap(useCase.send)
            .withUnretained(self)
            .sink { owner , _ in
                output.isSent.send(true)
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
            }
            .store(in: cancelBag)
        
        input.phoneTextFieldText
            .handleEvents(receiveOutput: { _ in
                output.phoneFailDescription.send(nil)
            })
            .withUnretained(self)
            .map { $1.count >= $0.useCase.policy.phoneMaxLength && $1.allSatisfy { $0.isNumber } }
            .sink { output.sendButtonIsEnabled.send($0) }
            .store(in: cancelBag)
        
        input.phoneTextFieldText
            .withUnretained(self)
            .filter { $1.count >= $0.useCase.policy.phoneMaxLength }
            .map {
                let newValue = $1.prefix($0.useCase.policy.phoneMaxLength)
                return String(newValue)
            }
            .sink { output.phoneTextFieldText.send($0) }
            .store(in: cancelBag)
        
        input.codeTextFieldText
            .withUnretained(self)
            .filter { $1.count >= $0.useCase.policy.codeMaxLength }
            .map {
                let newValue = $1.prefix($0.useCase.policy.codeMaxLength)
                return String(newValue)
            }
            .sink { output.codeTextFieldText.send($0) }
            .store(in: cancelBag)
        
        Publishers.CombineLatest(
            output.codeTextFieldText,
            output.timerIsRunning
        )
        .map { !$0.isEmpty && $1 }
        .sink { output.doneButtonIsEnabled.send($0) }
        .store(in: cancelBag)
        
        input.doneButtonTapped
            .withLatestFrom(output.timerIsRunning)
            .filter { $0 }
            .mapVoid()
            .map { PhoneVerifyModel(
                name: nil,
                phone: output.phoneTextFieldText.value,
                code: output.codeTextFieldText.value,
                type: self.phoneVerifyType)
            }
            .flatMap(useCase.verify)
            .withUnretained(self)
            .sink { owner, _ in
                owner.timerCancellable = nil
                output.verifySuccess.send()
            }
            .store(in: cancelBag)
        
        return output
    }

}
