//
//  CoreAuthRepositoryInterface.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine
import Core

public protocol CoreAuthRepositoryInterface {
    func login(for provider: OAuthProvider, with identityToken: String) -> AnyPublisher<AuthTokens, CoreAuthError>
    func changeSocialAccount(_ model: SignUpModel) -> AnyPublisher<Void, CoreAuthError>
    func searchSocialAccount(_ phone: String) -> AnyPublisher<OAuthProvider, CoreAuthError>
    func signUp(_ model: SignUpModel) -> AnyPublisher<Void, CoreAuthError>
    func getRecentLogin() -> OAuthProvider?
    func saveRecentLogin(_ provider: OAuthProvider)
    func deleteRecentLogin()
}
