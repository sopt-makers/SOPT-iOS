//
//  NotificationFeatureBuildable.swift
//  NotificationFeatureInterface
//
//  Created by Jae Hyun Lee on 5/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain

public protocol NotificationFeatureBuildable {
    func makeNotificationList() -> NotificationListPresentable
    func makeNotificationDetailVC(notificationId: String) -> NotificationDetailPresentable
}
