//
//  SignUpUseCase.swift
//  Domain
//
//  Created by 장석우 on 1/4/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine
import Foundation

import Core

public protocol SignUpUseCase {
    func signUp(with provider: OAuthProvider, phone: String) -> AnyPublisher<Void, Never>
    var sideEffect: PassthroughSubject<CoreAuthError, Never> { get }
}

public struct DefaultSignUpUseCase {
    
    private let repository: CoreAuthRepositoryInterface
    private let oAuthRepository: CoreOAuthRepositoryInterface
    private let tokenRepositroy: AuthTokensRepositoryInterface
    
    private var cancelBag = CancelBag()
    
    public let sideEffect = PassthroughSubject<CoreAuthError, Never>()
    
    public init(
        repository: CoreAuthRepositoryInterface,
        oAuthRepository: CoreOAuthRepositoryInterface,
        tokenRepositroy: AuthTokensRepositoryInterface
    ) {
        self.repository = repository
        self.oAuthRepository = oAuthRepository
        self.tokenRepositroy = tokenRepositroy
    }
}

extension DefaultSignUpUseCase: SignUpUseCase {
    public func signUp(
        with provider: OAuthProvider,
        phone: String
    ) -> AnyPublisher<Void, Never> {
        oAuthRepository.getIdentityToken(from: provider)
            .map { SignUpModel(phone: phone, token: $0, provider: provider)}
            .flatMap(self.repository.signUp)
            .handleEvents(receiveOutput: { _ in
                repository.deleteRecentLogin()
            })
            .mapVoid()
            .catch { error in
                self.sideEffect.send(error)
                return Empty<Void, Never>()
            }
            .eraseToAnyPublisher()
    }
}

public struct StubSignUpUseCase: SignUpUseCase {
    
    public init() {}
    
    public let sideEffect =  PassthroughSubject<CoreAuthError, Never>()
    
    public func signUp(with provider: OAuthProvider, phone: String) -> AnyPublisher<Void, Never> {
        Just(()).eraseToAnyPublisher()
    }
}
