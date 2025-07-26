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
    // legacy
    func requestSignIn(token: String)
    var signInSuccess: CurrentValueSubject<SiginInHandleableType, Error> { get set }
    
    // 인증 중앙화
    func getRecentLogin() -> OAuthProvider?
    func login(with provider: OAuthProvider) -> AnyPublisher<Void, Never>
    var sideEffect: PassthroughSubject<CoreAuthError, Never> { get }
}

public class DefaultSignInUseCase {

    private let repository: SignInRepositoryInterface
    private let oauthRepository: CoreOAuthRepositoryInterface
    private let coreRepository: CoreAuthRepositoryInterface
    private let tokenRepository: AuthTokensRepositoryInterface
    
    private var cancelBag = CancelBag()
    
    public var sideEffect = PassthroughSubject<CoreAuthError, Never>()
    public var signInSuccess = CurrentValueSubject<SiginInHandleableType, Error>(.loginFailure)
    
    public init(
        repository: SignInRepositoryInterface,
        oauthRepository: CoreOAuthRepositoryInterface,
        coreRepository: CoreAuthRepositoryInterface,
        tokenRepository: AuthTokensRepositoryInterface
    ) {
        self.repository = repository
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
            .handleEvents(receiveOutput: tokenRepository.save)
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

//MARK: - LegacyAuth 로직

extension DefaultSignInUseCase {
    public func requestSignIn(token: String) {
        repository.requestSignIn(token: token)
            .handleEvents(receiveOutput: { model in
                self.tokenRepository.save(model.tokens)
                UserDefaultKeyList.Auth.isActiveUser = model.status == .active
            })
            .flatMap { _ in
                self.repository.fetchSoptampUser()
            }
            .sink { event in
                switch event {
                case .failure(let error):
                    print(error)
                    self.signInSuccess.send(.loginFailure)
                case .finished:
                    print("SignInUseCase: \(event)")
                }
            } receiveValue: { isSuccessed in
                self.signInSuccess.send(isSuccessed ? .loginSuccess : .loginFailure)
            }.store(in: self.cancelBag)
    }
}
