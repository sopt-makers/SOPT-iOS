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
                    // NOTE: signin에서 400이 날아오는 경우는 현재 기준 한가지 경우.
                    // 4월 19일 기준으로 대응됨. 만약 다르게 날아오거나 에러스펙을 새로 정의하는 경우 다시 리팩토링 해야 함.
                    // @승호. 2023 04 19
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
