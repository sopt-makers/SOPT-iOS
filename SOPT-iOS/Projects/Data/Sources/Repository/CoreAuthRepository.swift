//
//  CoreAuthRepository.swift
//  Data
//
//  Created by 장석우 on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain
import Networks

public struct CoreAuthRepository {
    
    private let coreAuthService: CoreAuthService
    
    public init(coreAuthService: CoreAuthService) {
        self.coreAuthService = coreAuthService
    }
}

extension CoreAuthRepository: CoreAuthRepositoryInterface {

    public func login(
        for provider: OAuthProvider,
        with identityToken: String
    ) -> AnyPublisher<CoreAuthTokens, CoreAuthError> {
        coreAuthService
            .login(.init(token: identityToken, authPlatform: provider.toData()))
            .compactMap { $0.data?.toDomain() }
            .mapError { _ in
                return CoreAuthError.loginFail
            }
            .eraseToAnyPublisher()
    }
    
    public func saveTokens(_ tokens: Domain.CoreAuthTokens) {
        UserDefaultKeyList.CoreAuth.accessToken = tokens.accessToken
        UserDefaultKeyList.CoreAuth.refreshToken = tokens.refreshToken
    }
    
    public func changeSocialAccount() -> AnyPublisher<Void, CoreAuthError> {
        fatalError()
    }
    
    public func searchSocialAccount() -> AnyPublisher<Void, CoreAuthError> {
        fatalError()
    }
    
    public func signUp(_ model: Domain.SignUpModel) -> AnyPublisher<Void, CoreAuthError> {
        coreAuthService
            .signUp(model.toData())
            .mapVoid()
            .mapError { _ in CoreAuthError.signUpFail }
            .eraseToAnyPublisher()
    }
}
