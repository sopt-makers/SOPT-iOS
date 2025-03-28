//
//  MockCoreOAuthRepository.swift
//  DomainTests
//
//  Created by 장석우 on 3/28/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Domain

final class MockCoreOAuthRepository: CoreOAuthRepositoryInterface {
    
    var getIdentityTokenResult: Result<String, Domain.CoreAuthError>!
    func getIdentityToken(from provider: Domain.OAuthProvider) -> AnyPublisher<String, Domain.CoreAuthError> {
        getIdentityTokenResult.publisher.eraseToAnyPublisher()
    }
}
