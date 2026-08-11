//
//  StubUserService.swift
//  AuthFeatureTests
//
//  Created by 장석우 on 10/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Core
import Domain
import AuthFeatureInterface

struct StubSignInRepository: SignInRepositoryInterface {
    func requestSignIn(token: String) -> AnyPublisher<SignInModel, Error> {
        let model = SignInModel(
            tokens: LegacyAuthTokensModel(accessToken: "stub", refreshToken: "stub", playgroundToken: "stub"),
            status: .active
        )
        return Just(model).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func fetchSoptampUser() -> AnyPublisher<Bool, Never> {
        Just(true).eraseToAnyPublisher()
    }
}

struct StubCoreOAuthRepository: CoreOAuthRepositoryInterface {
    func getIdentityToken(from provider: OAuthProvider) -> AnyPublisher<String, CoreAuthError> {
        Just("stub-identity-token").setFailureType(to: CoreAuthError.self).eraseToAnyPublisher()
    }
}

struct StubCoreAuthRepository: CoreAuthRepositoryInterface {
    func login(for provider: OAuthProvider, with identityToken: String) -> AnyPublisher<AuthTokens, CoreAuthError> {
        Empty().eraseToAnyPublisher()
    }

    func changeSocialAccount(_ model: SignUpModel) -> AnyPublisher<Void, CoreAuthError> {
        Empty().eraseToAnyPublisher()
    }

    func searchSocialAccount(_ phone: String) -> AnyPublisher<OAuthProvider, CoreAuthError> {
        Empty().eraseToAnyPublisher()
    }

    func signUp(_ model: SignUpModel) -> AnyPublisher<Void, CoreAuthError> {
        Empty().eraseToAnyPublisher()
    }

    func getRecentLogin() -> OAuthProvider? { nil }
    func saveRecentLogin(_ provider: OAuthProvider) {}
    func deleteRecentLogin() {}
}

struct StubPhoneVerifyRepository: PhoneVerifyRepositoryInterface {
    func send(_ model: PhoneSendModel) -> AnyPublisher<Void, PhoneVerifyError> {
        Empty().eraseToAnyPublisher()
    }

    func verify(_ model: PhoneVerifyModel) -> AnyPublisher<Void, PhoneVerifyError> {
        Empty().eraseToAnyPublisher()
    }
}

struct StubAuthTokensRepository: AuthTokensRepositoryInterface {
    func refresh(completion: @escaping (Result<Void, ReissueError>) -> Void) {
        completion(.success(()))
    }

    func fetch() -> AuthTokens? { nil }
    func save(_ tokens: AuthTokens) {}
    func delete() {}
}
