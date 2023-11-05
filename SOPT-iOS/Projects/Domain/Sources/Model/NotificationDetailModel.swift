//
//  NotificationDetailModel.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct NotificationDetailModel {
    public let notificationId: Int
    public let userId: Int
    public let title: String
    public let content: String?
    public let deepLink: String?
    public let webLink: String?
    public let createdAt: String
    public let updatedAt: String?
    
    public var hasLink: Bool {
        self.hasWebLink || self.hasDeepLink
    }
    
    public var hasWebLink: Bool {
        guard let webLink = webLink, !webLink.isEmpty else {
            return false
        }
        return true
    }
    
    public var hasDeepLink: Bool {
        guard let deepLink = deepLink, !deepLink.isEmpty else {
            return false
        }
        return true
    }
    
    public init(notificationId: Int, userId: Int, title: String, content: String?,
                deepLink: String?, webLink: String?, createdAt: String, updatedAt: String?) {
        self.notificationId = notificationId
        self.userId = userId
        self.title = title
        self.content = content
        self.deepLink = deepLink
        self.webLink = webLink
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
