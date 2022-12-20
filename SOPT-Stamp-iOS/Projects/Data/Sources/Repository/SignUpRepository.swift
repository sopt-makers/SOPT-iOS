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
    public func getNicknameAvailable(nickname: String) -> AnyPublisher<Int, Error> {
        return networkService.getNicknameAvailable(nickname: nickname)
    }
    
    public func getEmailAvailable(email: String) -> AnyPublisher<Int, Error> {
        return networkService.getEmailAvailable(email: email)
    }
    
    public func postSignUp(signUpModel: SignUpModel) -> AnyPublisher<Int, Error> {
        return userService.postSignUp(signUpEntity: SignUpEntity(nickname: signUpModel.nickname,
                                                          email: signUpModel.email,
                                                          password: signUpModel.password))
    }
}
