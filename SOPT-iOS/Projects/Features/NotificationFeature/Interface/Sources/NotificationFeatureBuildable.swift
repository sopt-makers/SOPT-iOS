//
//  NotificationFeatureBuildable.swift
//  NotificationFeatureInterface
//
//  Created by Jae Hyun Lee on 5/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Domain
import BaseFeatureDependency

public protocol NotificationFeatureBuildable {
    func makeNotificationList(coordinator: Coordinator) -> NotificationListPresentable
    func makeNotificationDetailVC(notificationId: String) -> NotificationDetailPresentable
    func makeOfficialNotificationDetailVC(notificationId: String) -> OfficialNotificationDetailPresentable
    func makeImageZoomInVC(imageUrl: String) -> UIViewController
}
