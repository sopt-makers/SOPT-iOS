//
//  NotificationSettingRepository.swift
//  Data
//
//  Created by Ian on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public final class NotificationSettingRepository {
    private let userService: UserService
    
    public init(userService: UserService) {
        self.userService = userService
    }
}

extension NotificationSettingRepository: NotificationSettingRepositoryInterface {
    public func updateNotificationSettings(with notificationSettings: NotificationOptInModel) -> Driver<Bool> {
        self.userService
            .optInPushNotification(notificationSettings: notificationSettings.toEntity())
            .map { $0 == 200 }
            .asDriver()
    }
}
