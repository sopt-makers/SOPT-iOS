//
//  NotificationListModel.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Core

public struct NotificationListModel: Hashable {
    public let notificationId: Int
    public let userId: Int
    public let title: String
    public let content: String
    public let category: String?
    public var isRead: Bool
    public let createdAt: String
    public var formattedCreatedAt: String {
        self.createdAt.serverTimeToString(forUse: .forNotification)
    }

    public init(notificationId: Int, userId: Int, title: String, content: String, category: String?, isRead: Bool, createdAt: String) {
        self.notificationId = notificationId
        self.userId = userId
        self.title = title
        self.content = content
        self.category = category
        self.isRead = isRead
        self.createdAt = createdAt
    }
}
