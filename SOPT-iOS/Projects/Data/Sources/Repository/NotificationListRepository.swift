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
    
    private let service: NotificationService
    private let cancelBag = CancelBag()
    
    public init(service: NotificationService) {
        self.service = service
    }
}

extension NotificationListRepository: NotificationListRepositoryInterface {
    public func getNotificationList(page: Int) -> AnyPublisher<[Domain.NotificationListModel], Error> {
        service.getNotificationList(page: page)
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
}
