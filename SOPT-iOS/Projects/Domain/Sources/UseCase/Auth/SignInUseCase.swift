//
//  SignInUseCase.swift
//  Presentation
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core

public enum SiginInHandleableType {
    case loginSuccess
    case loginFailure
}

public protocol SignInUseCase {
    func getRecentLogin() -> OAuthProvider?
    func login(with provider: OAuthProvider) -> AnyPublisher<Void, Never>
    var sideEffect: PassthroughSubject<CoreAuthError, Never> { get }
}

public class DefaultSignInUseCase {

    private let oauthRepository: CoreOAuthRepositoryInterface
    private let coreRepository: CoreAuthRepositoryInterface
    private let tokenRepository: AuthTokensRepositoryInterface

    private var cancelBag = CancelBag()

    public var sideEffect = PassthroughSubject<CoreAuthError, Never>()
    public var signInSuccess = CurrentValueSubject<SiginInHandleableType, Error>(.loginFailure)

    public init(
        oauthRepository: CoreOAuthRepositoryInterface,
        coreRepository: CoreAuthRepositoryInterface,
        tokenRepository: AuthTokensRepositoryInterface
    ) {
        self.oauthRepository = oauthRepository
        self.coreRepository = coreRepository
        self.tokenRepository = tokenRepository
    }
}

//MARK: - 인증중앙화(CoreAuth) 로직

extension DefaultSignInUseCase: SignInUseCase {
    
    public func login(with provider: OAuthProvider) -> AnyPublisher<Void, Never> {
        oauthRepository.getIdentityToken(from: provider)
            .map { (provider, $0) }
            .flatMap(coreRepository.login)
            .handleEvents(receiveOutput: { [weak self] token in
                self?.tokenRepository.save(token)
                self?.coreRepository.saveRecentLogin(provider)
            })
            .mapVoid()
            .catch { [weak self] in
                self?.sideEffect.send($0)
                return Empty<Void, Never>()
            }
            .eraseToAnyPublisher()
    }
    
    public func getRecentLogin() -> OAuthProvider? {
        coreRepository.getRecentLogin()
    }
}
