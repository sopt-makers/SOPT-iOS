//
//  MainRepository.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class MainRepository {
    
    private let userService: UserService
    private let cancelBag = CancelBag()
    
    public init(service: UserService) {
        self.userService = service
    }
}

extension MainRepository: MainRepositoryInterface {
    public func getUserMainInfo() -> AnyPublisher<Domain.MainModel?, Error> {
        userService.getUserMainInfo()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
