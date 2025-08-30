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
    func resetSocialAccount(with provider: OAuthProvider, phone: String) -> AnyPublisher<Void, Never>
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
        phone: String
    ) -> AnyPublisher<Void, Never> {
        oAuthRepository.getIdentityToken(from: provider)
            .map { SignUpModel(phone: phone, token: $0, provider: provider) }
            .flatMap(repository.changeSocialAccount)
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
