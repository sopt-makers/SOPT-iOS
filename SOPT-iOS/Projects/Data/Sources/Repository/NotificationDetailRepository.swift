//
//  NotificationDetailRepository.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class NotificationDetailRepository {
    
    private let service: NotificationService
    private let cancelBag = CancelBag()
    
    public init(service: NotificationService) {
        self.service = service
    }
}

extension NotificationDetailRepository: NotificationDetailRepositoryInterface {
    public func readNotification(notificationId: Int) -> AnyPublisher<Bool, Error> {
        service.readNotification(notificationId: notificationId)
            .map { $0 == 200 }
            .eraseToAnyPublisher()
    }
    
    public func getNotificationDetail(notificationId: Int) -> AnyPublisher<NotificationDetailModel, Error> {
        service.getNotificationDetail(notificationId: notificationId)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
