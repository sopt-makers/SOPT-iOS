//
//  NotificationListRepositoryInterface.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

public protocol NotificationListRepositoryInterface {
    func getNotificationList(page: Int) -> AnyPublisher<[NotificationListModel], Error>
    func readAllNotifications() -> AnyPublisher<Bool, Error>
}
