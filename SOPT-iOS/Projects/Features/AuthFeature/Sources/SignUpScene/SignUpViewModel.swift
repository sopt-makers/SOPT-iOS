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

typealias SignUpPhoneVerifyUseCase = SignUpUseCase & PhoneVerifyUseCase

public class SignUpViewModel: SignUpViewModelType {

    private let useCase: SignUpPhoneVerifyUseCase
    
    private let timerPublisher: Timer.TimerPublisher
    @Published private var timerCancellable: AnyCancellable?
    
    // MARK: - Inputs
    
    enum Step: Int {
        case phoneVerify = 1
        case oAuth = 2
    }
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let phoneVerify: PhoneVerify
        let oauth: OAuth
        
        public struct PhoneVerify {
            let sendButtonTapped: Driver<Void>
            let doneButtonTapped: Driver<Void>
            let phoneTextFieldText: Driver<String>
            let codeTextFieldText: Driver<String>
        }
        
        public struct OAuth {
            let googleLoginTapped: Driver<Void>
            let appleLoginTapped: Driver<Void>
        }
        
        init(
            viewDidLoad: Driver<Void>,
            phoneVerify: PhoneVerify,
            oauth: OAuth
        ) {
            self.viewDidLoad = viewDidLoad
            self.phoneVerify = phoneVerify
            self.oauth = oauth
        }
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let currentStep = CurrentValueSubject<Step, Never>(.phoneVerify)
        let phoneVerify: PhoneVerify
        let oauth: OAuth
        
        public struct PhoneVerify {
            let isSent = CurrentValueSubject<Bool, Never>(false)
            let verifySuccess = PassthroughSubject<Void, Never>()
            let failDescription = PassthroughSubject<String?, Never>()
            let showToast = PassthroughSubject<String, Never>()
            let timeLeft = PassthroughSubject<Int, Never>()
            let timerIsRunning = PassthroughSubject<Bool, Never>()
            let sendButtonIsEnabled = CurrentValueSubject<Bool, Never>(false)
            let doneButtonIsEnabled =  CurrentValueSubject<Bool, Never>(false)
        }
        
        public struct OAuth {
            
        }
    }
    
    // MARK: - init
    
    init(
        useCase: SignUpPhoneVerifyUseCase,
        timerPublisher: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .default)
    ) {
        self.useCase = useCase
        self.timerPublisher = timerPublisher
    }
}

extension SignUpViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let phoneVerify = transform(from: input.phoneVerify, cancelBag: cancelBag)
        let oAuth = transform(from: input.oauth, cancelBag: cancelBag)
        let output = Output(phoneVerify: phoneVerify, oauth: oAuth)
      
        phoneVerify.verifySuccess
            .withUnretained(self)
            .sink { owner, _ in
                output.currentStep.send(.oAuth)
            }
            .store(in: cancelBag)
        
        
        return output
    }
}

extension SignUpViewModel {
    
    private func transform(from input: Input.PhoneVerify, cancelBag: CancelBag) -> Output.PhoneVerify {
        let output = Output.PhoneVerify()
        
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
    
    public func transform(from input: Input.OAuth, cancelBag: CancelBag) -> Output.OAuth {
        let output = Output.OAuth()
        
        
        
        return output
    }
}
