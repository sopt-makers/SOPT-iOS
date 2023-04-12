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
    
    private let networkService: UserService
    private let cancelBag = CancelBag()
    
    public init(service: UserService) {
        self.networkService = service
    }
}

extension SignUpRepository: SignUpRepositoryInterface {
    public func getNicknameAvailable(nickname: String) -> AnyPublisher<Bool, Error> {
        return networkService.getNicknameAvailable(nickname: nickname).map { statusCode in
            statusCode == 200
        }.eraseToAnyPublisher()
    }
}
