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
    
    var loginResult: Result<Domain.CoreAuthTokens,Domain.CoreAuthError>!
    func login(for provider: Domain.OAuthProvider, with identityToken: String) -> AnyPublisher<Domain.CoreAuthTokens, Domain.CoreAuthError> {
        return loginResult.publisher.eraseToAnyPublisher()
    }
    
    var changeSocialAccountResult: Result<Void, Domain.CoreAuthError>!
    func changeSocialAccount() -> AnyPublisher<Void, Domain.CoreAuthError> {
        return changeSocialAccountResult.publisher.eraseToAnyPublisher()
    }
    
    var searchSocialAccountResult: Result<Void, Domain.CoreAuthError>!
    func searchSocialAccount() -> AnyPublisher<Void, Domain.CoreAuthError> {
        return searchSocialAccountResult.publisher.eraseToAnyPublisher()
    }
    
    var signUpRequest: SignUpModel!
    var signUpResult: Result<Void, Domain.CoreAuthError>!
    func signUp(_ model: Domain.SignUpModel) -> AnyPublisher<Void, Domain.CoreAuthError> {
        signUpRequest = model
        return signUpResult.publisher.eraseToAnyPublisher()
    }
    
    var saveTokensRequest: Domain.CoreAuthTokens!
    func saveTokens(_ tokens: Domain.CoreAuthTokens) {
        saveTokensRequest = tokens
        return
    }

}


