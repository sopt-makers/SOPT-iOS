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

public class SignUpPhoneVerifyViewModel: SignUpPhoneVerifyViewModelType {
    
    private let useCase: SignUpPhoneVerifyUseCase
    
    private let clock: ContinuousClock = ContinuousClock()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let sendButtonTapped: Driver<Void>
        let doneButtonTapped: Driver<Void>
        let phoneTextFieldText: Driver<String>
        let codeTextFieldText: Driver<String>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let verifySuccess = PassthroughSubject<Void, Never>()
        let verifyFail = PassthroughSubject<String?, Never>()
        let showToast = PassthroughSubject<String, Never>()
        let timeLeft = CurrentValueSubject<Int, Never>(180)
        let messageSent = CurrentValueSubject<Bool, Never>(false)
        let sendButtonIsEnabled = CurrentValueSubject<Bool, Never>(false)
        let doneButtonIsEnabled = CurrentValueSubject<Bool, Never>(false)
    }
    
    // MARK: - init
    
    init(useCase: SignUpPhoneVerifyUseCase) {
        self.useCase = useCase
    }
}

extension SignUpPhoneVerifyViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        
        useCase.sideEffect.sink { err in
            switch err {
            case .invalidVerifyCode:
                return
            case .timeout:
                return
            }
        }
        .store(in: cancelBag)
        
        input.sendButtonTapped
            .handleEvents(receiveOutput: { _ in
                output.verifyFail.send(nil) }
            )
            .combineLatest(input.phoneTextFieldText)
            .map { $1 }
            .map { PhoneSendModel(name: nil, phone: $0, type: .register) }
            .flatMap(useCase.send)
            .sink { [weak self] _ in
                output.messageSent.send(true)
                output.showToast.send("인증번호가 전송되었어요.")
            }
            .store(in: cancelBag)
        
        input.phoneTextFieldText
            .map { $0.count >= 11 && $0.allSatisfy { $0.isNumber } }
            .sink { output.sendButtonIsEnabled.send($0) }
            .store(in: cancelBag)
        
        input.codeTextFieldText
            .map { !$0.isEmpty }
            .sink { output.doneButtonIsEnabled.send($0) }
            .store(in: cancelBag)
        
        input.doneButtonTapped
            .combineLatest(
                input.phoneTextFieldText,
                input.codeTextFieldText
            )
            .map { PhoneVerifyModel(name: nil, phone: $1, code: $2, type: .register)}
            .flatMap(useCase.verify)
            .sink { output.verifySuccess.send($0) }
            .store(in: cancelBag)
        
        return output
    }
}

