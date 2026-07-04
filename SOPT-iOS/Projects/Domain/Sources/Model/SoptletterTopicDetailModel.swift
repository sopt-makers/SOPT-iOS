//
//  SoptletterTopicDetailModel.swift
//  Domain
//
//  Created by 최주리 on 7/3/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct SoptletterTopicDetailModel {
    public let topicId: Int
    public let title: String
    public let active: Bool
    public let startedAt: String
    public let endedAt: String
    public let createdAt: String
    
    public init(
        topicId: Int,
        title: String,
        active: Bool,
        startedAt: String,
        endedAt: String,
        createdAt: String
    ) {
        self.topicId = topicId
        self.title = title
        self.active = active
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.createdAt = createdAt
    }
}
