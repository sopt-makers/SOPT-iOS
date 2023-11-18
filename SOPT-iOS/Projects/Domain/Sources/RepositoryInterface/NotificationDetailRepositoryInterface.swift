//
//  NotificationDetailRepositoryInterface.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

import Combine

public protocol NotificationDetailRepositoryInterface {
    func readNotification(notificationId: String) -> AnyPublisher<Bool, Error>
    func getNotificationDetail(notificationId: String) -> AnyPublisher<NotificationDetailModel, Error>
}
