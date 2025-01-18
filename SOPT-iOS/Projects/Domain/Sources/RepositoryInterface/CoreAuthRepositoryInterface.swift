//
//  CoreAuthRepositoryInterface.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

public protocol CoreAuthRepositoryInterface {
    func login(for provider: OAuthType,with identityToken: String) -> AnyPublisher<CoreAuthTokens, CoreAuthError>
    func changeSocialAccount() -> AnyPublisher<Void, CoreAuthError>
    func searchSocialAccount() -> AnyPublisher<Void, CoreAuthError>
    func signUp(_ model: SignUpModel) -> AnyPublisher<Void, CoreAuthError>
    func saveTokens(_ tokens: CoreAuthTokens) -> Void
}
