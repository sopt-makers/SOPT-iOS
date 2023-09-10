//
//  NotificationListModel.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct NotificationListModel: Hashable {
    public let id: Int
    public let userId: Int
    public let title: String
    public let content: String
    public let type: String?
    public var isRead: Bool
    public let createdAt: String
    public let updatedAt: String?

    public init(id: Int, userId: Int, title: String, content: String, type: String?, isRead: Bool, createdAt: String, updatedAt: String?) {
        self.id = id
        self.userId = userId
        self.title = title
        self.content = content
        self.type = type
        self.isRead = isRead
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
