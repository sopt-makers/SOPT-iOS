//
//  NotificationDetailTransform.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Network

extension NotificationDetailEntity {

    public func toDomain() -> NotificationDetailModel {
        return NotificationDetailModel.init(notificationId: notificationId,
                                            userId: userId,
                                            title: title,
                                            content: content,
                                            deepLink: deepLink,
                                            webLink: webLink,
                                            createdAt: createdAt,
                                            updatedAt: updatedAt)
    }
}
