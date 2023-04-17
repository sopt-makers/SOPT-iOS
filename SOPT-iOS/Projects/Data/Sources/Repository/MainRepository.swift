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
    private let configService: ConfigService
    private let cancelBag = CancelBag()
    
    public init(userService: UserService, configService: ConfigService) {
        self.userService = userService
        self.configService = configService
    }
}

extension MainRepository: MainRepositoryInterface {
    public func getUserMainInfo() -> AnyPublisher<Domain.UserMainInfoModel?, Error> {
        userService.getUserMainInfo()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    public func getServiceState() -> AnyPublisher<ServiceStateModel, Error> {
        configService.getServiceAvailability()
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
