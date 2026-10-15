//
//  SoptletterTopicListModel.swift
//  Domain
//
//  Created by 최주리 on 7/3/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct SoptletterTopicListModel {
    public let topics: [SoptletterTopicModel]
    
    public init(topics: [SoptletterTopicModel]) {
        self.topics = topics
    }
}

public struct SoptletterTopicModel {
    public let topicId: Int
    public let title: String
    public let subtitle: String?
    public let isDefault: Bool
    public let isNew: Bool
    public let isHot: Bool
    public let unreadCount: Int
    public let createdAt: String
    
    public init(
        topicId: Int,
        title: String,
        subtitle: String?,
        isDefault: Bool,
        isNew: Bool,
        isHot: Bool,
        unreadCount: Int,
        createdAt: String
    ) {
        self.topicId = topicId
        self.title = title
        if let subtitle = subtitle {
            self.subtitle = subtitle
        } else {
            self.subtitle = nil
        }
        self.isDefault = isDefault
        self.isNew = isNew
        self.isHot = isHot
        self.unreadCount = unreadCount
        self.createdAt = createdAt
    }
}
