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
    func requestSignIn(token: String)
    func login(with provider: OAuthType) -> AnyPublisher<String, Never>
    var signInSuccess: CurrentValueSubject<SiginInHandleableType, Error> { get set }
}

public class DefaultSignInUseCase {
    
    private let repository: SignInRepositoryInterface
    private let oauthRepository: CoreOAuthRepositoryInterface
    
    private var cancelBag = CancelBag()
    
    public var signInSuccess = CurrentValueSubject<SiginInHandleableType, Error>(.loginFailure)
    
    public init(
        repository: SignInRepositoryInterface,
        oauthRepository: CoreOAuthRepositoryInterface
    ) {
        self.repository = repository
        self.oauthRepository = oauthRepository
    }
}

extension DefaultSignInUseCase: SignInUseCase {
    public func requestSignIn(token: String) {
        repository.requestSignIn(token: token)
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
    
    public func login(with provider: OAuthType) -> AnyPublisher<String, Never> {
        oauthRepository.getIdentityToken(from: .apple)
            .catch { _ in
                return Empty<String, Never>()
            }
            .eraseToAnyPublisher()
    }
}
