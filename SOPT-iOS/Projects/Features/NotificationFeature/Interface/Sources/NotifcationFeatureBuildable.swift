//
//  NotifcationFeatureBuildable.swift
//  NotificationFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain

public protocol NotificationFeatureBuildable {
    func makeNotificationList() -> NotificationListPresentable
    func makeNotificationDetailVC(notificationId: Int) -> NotificationDetailPresentable
}
