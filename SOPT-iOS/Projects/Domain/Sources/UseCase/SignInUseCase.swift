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
    var signInSuccess: CurrentValueSubject<SiginInHandleableType, Error> { get set }
}

public class DefaultSignInUseCase {
    
    private let repository: SignInRepositoryInterface
    private var cancelBag = CancelBag()
    public var signInSuccess = CurrentValueSubject<SiginInHandleableType, Error>(.loginFailure)
    
    public init(repository: SignInRepositoryInterface) {
        self.repository = repository
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
}
