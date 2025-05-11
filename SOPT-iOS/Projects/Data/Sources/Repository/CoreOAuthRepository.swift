//
//  CoreOAuthRepository.swift
//  Data
//
//  Created by 장석우 on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Domain
import Networks

public struct OAuthServiceFactory {
    
    public init() { }
    
    func create(_ oAuthProvider: OAuthProvider) -> OAuthService {
        switch oAuthProvider {
        case .apple: return AppleOAuthService()
        case .google: return GoogleOAuthService()
        }
    }
}

public class CoreOAuthRepository {
    
    private let oAuthServiceFactory: OAuthServiceFactory
    
    public init(oAuthServiceFactory: OAuthServiceFactory) {
        self.oAuthServiceFactory = oAuthServiceFactory
    }
}

extension CoreOAuthRepository: CoreOAuthRepositoryInterface {
    
    public func getIdentityToken(from provider: OAuthProvider) -> AnyPublisher<String, Domain.CoreAuthError> {
        let oAuthService = oAuthServiceFactory.create(provider)
        return oAuthService.getIdentityToken()
            .mapError { _ in CoreAuthError.oAuthFail(provider) } // oauth error의 구체화 필요시 여기서 구현
            .eraseToAnyPublisher()
    }
}
