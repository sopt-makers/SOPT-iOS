//
//  SignInUseCase.swift
//  Presentation
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core

public protocol SignInUseCase {
    func requestSignIn(signInRequest: SignInRequest)
    var signInSuccess: CurrentValueSubject<Bool, Error> { get set }
}

public class DefaultSignInUseCase {
  
    private let repository: SignInRepositoryInterface
    private var cancelBag = CancelBag()
    public var signInSuccess = CurrentValueSubject<Bool, Error>(false)

    public init(repository: SignInRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultSignInUseCase: SignInUseCase {
    public func requestSignIn(signInRequest: SignInRequest) {
        repository.requestSignIn(request: signInRequest).sink { event in
            print("SignInUseCase: \(event)")
        } receiveValue: { signInModel in
            self.signInSuccess.send(signInModel.userId != nil)
        }.store(in: self.cancelBag)
    }
}
