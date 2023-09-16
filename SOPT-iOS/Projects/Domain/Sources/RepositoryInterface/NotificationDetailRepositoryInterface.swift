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
    func readNotification(notificationId: Int) -> AnyPublisher<Bool, Error>
}
