//
//  NotificationSettingRepositoryInterface.swift
//  Domain
//
//  Created by Ian on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine
import Core

public protocol NotificationSettingRepositoryInterface {
    func getNotificationSettingsInDetail() -> Driver<NotificationOptInModel>
    func updateNotificationSettings(with notificationSettings: NotificationOptInModel) -> Driver<NotificationOptInModel>
}
