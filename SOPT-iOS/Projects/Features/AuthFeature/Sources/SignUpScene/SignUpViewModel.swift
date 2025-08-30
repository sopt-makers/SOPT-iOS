//
//  SignUpViewModel.swift
//  AuthFeature
//
//  Created by 장석우 on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain

final class SignUpViewModel: SignUpViewModelType {
    
    enum Step: Int {
        case phoneVerify
        case oAuth
    }
    
    struct Input {
        let phone: Driver<String>
        let verifySuccess: Driver<Void>
        let loginHelpButtonTapped: Driver<Void>
        var oAuth: OAuth
        
        struct OAuth {
            let googleLoginTapped: Driver<Void>
            let appleLoginTapped: Driver<Void>
        }
    }
    
    struct Output {
        let currentStep = CurrentValueSubject<Step, Never>(.phoneVerify)
        let signUpSucceed = PassthroughSubject<Void, Never>()
    }
    
    private let useCase: SignUpUseCase
    public var onLoginHelpButtonTapped: (() -> Void)?
    public var onSignUpSuccess: (() -> Void)?
    
    init(
        useCase: SignUpUseCase
    ) {
        self.useCase = useCase
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.verifySuccess
            .sink { _ in
                output.currentStep.send(.oAuth)
            }
            .store(in: cancelBag)
        
        input.loginHelpButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onLoginHelpButtonTapped?()
            }
            .store(in: cancelBag)
        
        Publishers.Merge(
            input.oAuth.googleLoginTapped.map { OAuthProvider.google },
            input.oAuth.appleLoginTapped.map { OAuthProvider.apple }
        )
        .withLatestFrom(input.phone)
        .withUnretained(self)
        .flatMap { owner, output in
            owner.useCase.signUp(with: output.0, phone: output.1)
        }
        .withUnretained(self)
        .sink { owner, _ in
            output.signUpSucceed.send(())
            owner.onSignUpSuccess?()
        }
        .store(in: cancelBag)
        
        return output
    }
}
