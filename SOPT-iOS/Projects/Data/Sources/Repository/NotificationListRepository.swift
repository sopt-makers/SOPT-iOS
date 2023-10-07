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
import Networks

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
    
    public func readAllNotifications() -> AnyPublisher<Bool, Error> {
        service.readNotification(notificationId: nil)
            .map { $0 == 200 }
            .eraseToAnyPublisher()
    }
}
