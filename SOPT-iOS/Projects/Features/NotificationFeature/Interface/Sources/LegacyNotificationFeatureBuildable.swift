//
//  LegacyNotificationFeatureBuildable.swift
//  NotificationFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain

public protocol LegacyNotificationFeatureBuildable {
    func makeNotificationList() -> LegacyNotificationListPresentable
    func makeNotificationDetailVC(notificationId: String) -> LegacyNotificationDetailPresentable
}
