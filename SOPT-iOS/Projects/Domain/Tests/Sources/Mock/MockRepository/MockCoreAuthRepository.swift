//
//  MockCoreAuthRepository.swift
//  DomainTests
//
//  Created by 장석우 on 3/28/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Domain

final class MockCoreAuthRepository: CoreAuthRepositoryInterface {
    
    var loginResponse: Result<Domain.CoreAuthTokens,Domain.CoreAuthError>!
    func login(for provider: Domain.OAuthProvider, with identityToken: String) -> AnyPublisher<Domain.CoreAuthTokens, Domain.CoreAuthError> {
        loginResponse.publisher.eraseToAnyPublisher()
    }
    
    func changeSocialAccount() -> AnyPublisher<Void, Domain.CoreAuthError> {
        Empty().eraseToAnyPublisher()
    }
    
    func searchSocialAccount() -> AnyPublisher<Void, Domain.CoreAuthError> {
        Empty().eraseToAnyPublisher()
    }
    
    var signUpRequest: SignUpModel!
    func signUp(_ model: Domain.SignUpModel) -> AnyPublisher<Void, Domain.CoreAuthError> {
        signUpRequest = model
        return  Empty().eraseToAnyPublisher()
    }
    
    func saveTokens(_ tokens: Domain.CoreAuthTokens) {
        return
    }

}


