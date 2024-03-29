//
//  NotificationListTransform.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension NotificationListEntity {
    public func toDomain() -> NotificationListModel {
        return NotificationListModel.init(notificationId: notificationId,
                                          userId: userId,
                                          title: title,
                                          content: content,
                                          category: category,
                                          isRead: isRead,
                                          createdAt: createdAt)
    }
}
