//
//  SignUpViewModelTests.swift
//  AuthFeatureTests
//
//  Created by 장석우 on 3/29/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Testing
import Combine

@testable import AuthFeature
@testable import Domain
@testable import Core

struct MockSignUseCase: SignUpUseCase {
    
    var signUpResult: Result<Void, Never>!
    func signUp(with provider: Domain.OAuthProvider, name: String?, phone: String) -> AnyPublisher<Void, Never> {
        signUpResult.publisher.eraseToAnyPublisher()
    }
    
    var sideEffect = PassthroughSubject<Domain.CoreAuthError, Never>()
}

struct SignUpViewModelTests {

    let mockUseCase = MockSignUseCase()
    lazy var sut = SignUpViewModel(useCase: mockUseCase)
    let cancelBag = CancelBag()
    
    @Test
    mutating func 회원가입_첫단계는_전화번호_인증이다() async throws {
        
        let input = SignUpViewModel.Input(phone: .empty(), verifySuccess: .empty(), loginHelpButtonTapped: .empty(), oAuth: .init(googleLoginTapped: .empty(), appleLoginTapped: .empty()))
        
        let output = sut.transform(from: input, cancelBag: cancelBag)
        
        #expect(output.currentStep.value == .phoneVerify)
    }

}
