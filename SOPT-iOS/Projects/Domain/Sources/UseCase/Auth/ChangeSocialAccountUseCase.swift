//
//  ResetSocialUseCase.swift
//  Domain
//
//  Created by 장석우 on 5/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine
import Core

public protocol ChangeSocialAccountUseCase {
    func resetSocialAccount(with provider: OAuthProvider, name: String?, phone: String) -> AnyPublisher<Void, Never>
    var sideEffect: PassthroughSubject<CoreAuthError, Never> { get }
}

public struct DefaultChangeSocialAccountUseCase: ChangeSocialAccountUseCase {
    
    private let oAuthRepository: CoreOAuthRepositoryInterface
    private let repository: CoreAuthRepositoryInterface
    private let tokenRepository: AuthTokensRepositoryInterface
    
    private var cancelBag = CancelBag()
    
    public let sideEffect = PassthroughSubject<CoreAuthError, Never>()
    
    public init(
        repository: CoreAuthRepositoryInterface,
        oAuthRepository: CoreOAuthRepositoryInterface,
        tokenRepository: AuthTokensRepositoryInterface
    ) {
        self.repository = repository
        self.oAuthRepository = oAuthRepository
        self.tokenRepository = tokenRepository
    }
        
    public func resetSocialAccount(
        with provider: OAuthProvider,
        name: String?,
        phone: String
    ) -> AnyPublisher<Void, Never> {
        oAuthRepository.getIdentityToken(from: provider)
            .map { SignUpModel(name: name, phone: phone, token: $0, provider: provider) }
            .flatMap { model in
                self.repository.changeSocialAccount(model)
                    .flatMap {
                        self.repository.login(for: provider, with: model.token)
                    }
            }
            .handleEvents(receiveOutput: self.tokenRepository.save)
            .mapVoid()
            .catch { error in
                self.sideEffect.send(error)
                return Empty<Void, Never>()
            }
            .eraseToAnyPublisher()
    }
}
