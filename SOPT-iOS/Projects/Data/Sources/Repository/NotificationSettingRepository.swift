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
import Networks

public final class NotificationSettingRepository {
    private let userService: UserService
    
    public init(userService: UserService) {
        self.userService = userService
    }
}

extension NotificationSettingRepository: NotificationSettingRepositoryInterface {
    public func getNotificationSettingsInDetail() -> Driver<NotificationOptInModel> {
        self.userService
            .getNotificationSettingsInDetail()
            .map { $0.toDomain() }
            .asDriver()
    }
    
    public func updateNotificationSettings(with notificationSettings: NotificationOptInModel) -> Driver<NotificationOptInModel> {
        self.userService
            .optInPushNotificationInDetail(notificationSettings: notificationSettings.toEntity())
            .map { $0.toDomain() }
            .asDriver()
    }
}
