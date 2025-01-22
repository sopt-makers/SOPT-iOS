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
    func signUp(with provider: OAuthProvider, name: String?, phone: String) -> AnyPublisher<Void, Never>
    var sideEffect: PassthroughSubject<CoreAuthError, Never> { get }
}

public struct DefaultSignUpUseCase {
    
    private let repository: CoreAuthRepositoryInterface
    private let oAuthRepository: CoreOAuthRepositoryInterface
    
    private var cancelBag = CancelBag()
    
    public let sideEffect = PassthroughSubject<CoreAuthError, Never>()
    
    public init(
        repository: CoreAuthRepositoryInterface,
        oAuthRepository: CoreOAuthRepositoryInterface
    ) {
        self.repository = repository
        self.oAuthRepository = oAuthRepository
    }
}

extension DefaultSignUpUseCase: SignUpUseCase {
    public func signUp(with provider: OAuthProvider, name: String?, phone: String) -> AnyPublisher<Void, Never> {
        oAuthRepository.getIdentityToken(from: provider)
            .map { SignUpModel(name: nil, phone: phone, code: $0, provider: provider)}
            .flatMap(self.repository.signUp)
            .catch { _ in
                self.sideEffect.send(.signUpFail)
                return Empty<Void, Never>()
            }
            .eraseToAnyPublisher()
    }
}

public struct StubSignUpUseCase: SignUpUseCase {
    
    public init() {}
    
    public let sideEffect =  PassthroughSubject<CoreAuthError, Never>()
    
    public func signUp(with provider: OAuthProvider, name: String?, phone: String) -> AnyPublisher<Void, Never> {
        Just(()).eraseToAnyPublisher()
    }
}
