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
    private let socialService: SocialService
    
    public init(
        coreAuthService: CoreAuthService,
        socialService: SocialService
    ) {
        self.coreAuthService = coreAuthService
        self.socialService = socialService
    }
}

extension CoreAuthRepository: CoreAuthRepositoryInterface {
    public func getRecentLogin() -> Domain.OAuthProvider? {
        OAuthProvider(rawValue: UserDefaultKeyList.CoreAuth.recentLogin ?? "")
    }
    
    public func saveRecentLogin(_ provider: Domain.OAuthProvider) {
        UserDefaultKeyList.CoreAuth.recentLogin = provider.rawValue
    }

    public func login(
        for provider: OAuthProvider,
        with identityToken: String
    ) -> AnyPublisher<AuthTokens, CoreAuthError> {
        coreAuthService
            .login(.init(token: identityToken, authPlatform: provider.toData()))
            .compactMap { $0.toDomain() }
            .mapError { error in
                if case let .statusCode(response) = error {
                    let response = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any]
                    let message = response?["message"] as? String
                    return CoreAuthError.loginFail(message)
                } else {
                    return CoreAuthError.loginFail(nil)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func signUp(_ model: Domain.SignUpModel) -> AnyPublisher<Void, CoreAuthError> {
        coreAuthService
            .signUp(model.toData())
            .mapError { error in
                if case let .statusCode(response) = error {
                    let response = try? JSONSerialization.jsonObject(with: response.data) as? [String: Any]
                    let message = response?["message"] as? String
                    return CoreAuthError.signUpFail(message)
                } else {
                    return CoreAuthError.signUpFail(nil)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func changeSocialAccount(_ model: Domain.SignUpModel) -> AnyPublisher<Void, Domain.CoreAuthError> {
        socialService
            .changeSocialAccount(model.toData())
            .mapVoid()
            .mapError { _ in CoreAuthError.changeSocialAccountFail }
            .eraseToAnyPublisher()
    }
    
    public func searchSocialAccount(_ phone: String) -> AnyPublisher<OAuthProvider, CoreAuthError> {
        socialService
            .getSocialAccount(for: phone)
            .compactMap { $0.data.toDomain() }
            .mapError { _ in CoreAuthError.changeSocialAccountFail }
            .eraseToAnyPublisher()
    }
}
