//
//  SignUpPhoneVerifiyViewModel.swift
//  AuthFeature
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

import AuthFeatureInterface
import Domain
import Core

public class SignUpPhoneVerifyViewModel: SignUpPhoneVerifyViewModelType {
    
    private let useCase: PhoneVerifyUseCase
//    private let clock: Clock
    private let cancelBag = CancelBag()
  
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let sendButtonTapped: Driver<Void>
        let signUpButtonTapped: Driver<Void>
        let phoneTextFieldText: Driver<String>
        let codeTextFieldText: Driver<String>
    }
    
    // MARK: - Outputs
    
    public struct Output {
        let verifySuccess = PassthroughSubject<Void, Never>()
        let verifyFail = PassthroughSubject<Error, Never>()
        let showToast = PassthroughSubject<String, Never>()
        let timeLeft = CurrentValueSubject<Int, Never>(180)
        let signUpButtonIsEnabled = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - init
    
    init(useCase: PhoneVerifyUseCase) {
        self.useCase = useCase
    }
}

extension SignUpPhoneVerifyViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, cancelBag: cancelBag)
        return output
    }
  
    private func bindOutput(output: Output, cancelBag: CancelBag) {
    }
}

