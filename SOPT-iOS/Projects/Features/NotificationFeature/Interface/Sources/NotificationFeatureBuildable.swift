//
//  NotificationFeatureBuildable.swift
//  NotificationFeatureInterface
//
//  Created by Jae Hyun Lee on 5/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import BaseFeatureDependency

public protocol NotificationFeatureBuildable {
    func makeNotificationList(coordinator: Coordinator) -> NotificationListPresentable
    func makeNotificationDetailVC(notificationId: String) -> NotificationDetailPresentable
}
