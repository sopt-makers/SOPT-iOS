//
//  NotificationDetailEntity.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct NotificationDetailEntity: Decodable {
    public let notificationId: Int
    public let userId: Int
    public let title: String
    public let content: String?
    public let deepLink: String?
    public let webLink: String?
    public let createdAt: String
    public let updatedAt: String?
}
