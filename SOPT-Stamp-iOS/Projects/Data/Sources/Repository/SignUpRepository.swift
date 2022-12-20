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
    private let cancelBag = CancelBag()
    
    public init(service: AuthService) {
        self.networkService = service
    }
}

extension SignUpRepository: SignUpRepositoryInterface {
    public func getNicknameAvailable(nickname: String) -> AnyPublisher<Int, Error> {
        return networkService.getNicknameAvailable(nickname: nickname)
    }
    
    public func getEmailAvailable(email: String) -> AnyPublisher<Int, Error> {
        return networkService.getEmailAvailable(email: email)
    }
}
