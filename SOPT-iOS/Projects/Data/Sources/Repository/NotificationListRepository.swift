//
//  NotificationListRepository.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class NotificationListRepository {
    
    private let networkService: AuthService
    private let cancelBag = CancelBag()
    
    public init(service: AuthService) {
        self.networkService = service
    }
}

extension NotificationListRepository: NotificationListRepositoryInterface {
    
}
