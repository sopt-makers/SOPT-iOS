//
//  NotificationSettingsTransform.swift
//  Data
//
//  Created by Ian on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Network

extension NotificationOptInModel {
    public func toEntity() -> DetailNotificationOptInEntity {
        return DetailNotificationOptInEntity(
            allOptIn: self.allOptIn,
            partOptIn: self.partOptIn,
            newsOptIn: self.newsOptIn
        )
    }
}
