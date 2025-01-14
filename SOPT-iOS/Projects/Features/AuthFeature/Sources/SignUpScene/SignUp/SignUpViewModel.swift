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
    
    private let useCase: SignUpUseCase

    enum Step: Int {
        case phoneVerify
        case oAuth
    }
    
    struct Input {
        let verifySuccess: Driver<Void>
        var oAuth: OAuth
        
        struct OAuth {
            let googleLoginTapped: Driver<Void>
            let appleLoginTapped: Driver<Void>
        }
    }
    
    struct Output {
        let currentStep = CurrentValueSubject<Step, Never>(.phoneVerify)
    }
    
    init(useCase: SignUpUseCase) {
        self.useCase = useCase
    }
    
    func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.verifySuccess
            .sink { _ in
                output.currentStep.send(.oAuth)
            }
            .store(in: cancelBag)
        
        return output
    }
}
