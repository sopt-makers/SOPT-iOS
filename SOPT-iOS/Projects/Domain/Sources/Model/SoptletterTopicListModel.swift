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
    public let isDefault: Bool
    public let createdAt: String
    
    public init(
        topicId: Int,
        title: String,
        isDefault: Bool,
        createdAt: String
    ) {
        self.topicId = topicId
        self.title = title
        self.isDefault = isDefault
        self.createdAt = createdAt
    }
}
