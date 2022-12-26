//
//  SignInRepository.swift
//  Data
//
//  Created by devxsby on 2022/12/01.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core

import Domain
import Network

public class SignInRepository {
    
    private let networkService: UserService
    private let cancelBag = CancelBag()
    
    public init(service: UserService) {
        self.networkService = service
    }
}

extension SignInRepository: SignInRepositoryInterface {
    
    public func requestSignIn(request: SignInRequest) -> AnyPublisher<SignInModel, Error> {
        networkService.requestSignIn(email: request.email, password: request.password).map { entity in
            entity.toDomain()
        }.eraseToAnyPublisher()
    }
    
}
