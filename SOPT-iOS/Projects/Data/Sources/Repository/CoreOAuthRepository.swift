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
        switch provider {
        case .apple: return appleService.getIdentityToken()
        case .google: fatalError() //TODO: 
        }
        
    }
}
