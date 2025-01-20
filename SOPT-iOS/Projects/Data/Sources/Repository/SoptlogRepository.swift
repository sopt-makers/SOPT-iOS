//
//  SoptlogRepository.swift
//  Data
//
//  Created by 강윤서 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class SoptlogRepository {
    
    private let userService: UserService
    
    private let cancelBag = CancelBag()
    
    public init(userService: UserService) {
        self.userService = userService
    }
}

extension SoptlogRepository: SoptlogRepositoryInterface {
    public func fetchSoptlogModel() -> AnyPublisher<Domain.SoptlogModel, any Error> {
        return self.userService.fetchSoptlogInfo()
            .map{ $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
