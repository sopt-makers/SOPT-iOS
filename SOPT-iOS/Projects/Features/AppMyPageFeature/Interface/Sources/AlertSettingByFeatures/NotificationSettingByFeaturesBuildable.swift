//
//  NotificationSettingByFeaturesBuildable.swift
//  AppMyPageFeatureTests
//
//  Created by Ian on 2023/09/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

public protocol NotificationSettingByFeaturesBuildable {
    func makeNotificationSettingByFeatures() -> NotificationSettingByFeaturesViewControllable
}
