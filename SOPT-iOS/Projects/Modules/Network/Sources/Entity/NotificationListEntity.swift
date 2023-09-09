//
//  NotificationListEntity.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/14.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct NotificationListEntity {
    public let id: Int
    public let userId: Int
    public let title: String
    public let content: String
    public let type: String?
    public let isRead: Bool
    public let createdAt: String
    public let updatedAt: String?
}
