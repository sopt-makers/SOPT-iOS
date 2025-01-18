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

public class CoreOAuthRepository {
    
    private let appleService: AuthenticationService
//    private let googleService:
    
    public init(appleService: AuthenticationService) {
        self.appleService = appleService
    }
}

extension CoreOAuthRepository: CoreOAuthRepositoryInterface {
    public func getIdentityToken(from provider: OAuthType) -> AnyPublisher<String, Domain.CoreAuthError> {
        let service: AuthenticationService
        switch provider {
        case .apple: service = appleService
        case .google: fatalError() //TODO:
        }
        
        return service.getIdentityToken()
            .mapError { _ in CoreAuthError.oAuthFail(provider) } // oauth error의 구체화 필요시 여기서 구현
            .eraseToAnyPublisher()
    }
}
