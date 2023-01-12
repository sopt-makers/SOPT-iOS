//
//  SignUpRepository.swift
//  Data
//
//  Created by sejin on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class SignUpRepository {
    
    private let networkService: AuthService
    private let userService: UserService
    private let cancelBag = CancelBag()
    
    public init(service: AuthService, userService: UserService) {
        self.networkService = service
        self.userService = userService
    }
}

extension SignUpRepository: SignUpRepositoryInterface {
    public func getNicknameAvailable(nickname: String) -> AnyPublisher<Bool, Error> {
        return networkService.getNicknameAvailable(nickname: nickname).map { statusCode in
            statusCode == 200
        }.eraseToAnyPublisher()
    }
    
    public func getEmailAvailable(email: String) -> AnyPublisher<Bool, Error> {
        return networkService.getEmailAvailable(email: email).map { statusCode in
            statusCode == 200
        }.eraseToAnyPublisher()
    }
    
    public func postSignUp(signUpRequest: SignUpModel) -> AnyPublisher<Bool, Error> {
        return userService.postSignUp(nickname: signUpRequest.nickname, email: signUpRequest.email, password: signUpRequest.password)
            .map { entity in
                guard let userId = entity?.userId else { return false }
                UserDefaultKeyList.Auth.userId = userId
                return true
            }.eraseToAnyPublisher()
    }
}
