//
//  ChangeSocialAccountViewModel.swift
//  AuthFeature
//
//  Created by 장석우 on 5/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain

public final class ChangeSocialAccountViewModel: ChangeSocialAccountViewModelType {
    
    enum Step: Int {
        case phoneVerify
        case oAuth
    }
    
    public struct Input {
        let phone: Driver<String>
        let verifySuccess: Driver<Void>
        var oAuth: OAuth
        
        public struct OAuth {
            let googleLoginTapped: Driver<Void>
            let appleLoginTapped: Driver<Void>
        }
    }
    
    public struct Output {
        let currentStep = CurrentValueSubject<Step, Never>(.phoneVerify)
        let changeSocialAccountSucceed = PassthroughSubject<Void, Never>()
        let errorToastMessage = PassthroughSubject<String, Never>()
    }
    
    private let useCase: ChangeSocialAccountUseCase
    
    public var changeSocialAccountSucceed: (() -> Void)?
    
    public init(
        useCase: ChangeSocialAccountUseCase
    ) {
        self.useCase = useCase
    }
    
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        useCase.sideEffect
            .map { $0.description }
            .sink { description in
                output.errorToastMessage.send(description)
        }
        .store(in: cancelBag)
        
        input.verifySuccess
            .sink { _ in
                output.currentStep.send(.oAuth)
            }
            .store(in: cancelBag)

        
        Publishers.Merge(
            input.oAuth.googleLoginTapped.map { OAuthProvider.google },
            input.oAuth.appleLoginTapped.map { OAuthProvider.apple }
        )
        .withLatestFrom(input.phone)
        .withUnretained(self)
        .flatMap { owner, output in
            owner.useCase.resetSocialAccount(with: output.0, phone: output.1)
        }
        .withUnretained(self)
        .sink { owner, _ in
            output.changeSocialAccountSucceed.send(())
            owner.changeSocialAccountSucceed?()
        }
        .store(in: cancelBag)
        
        return output
    }
}
