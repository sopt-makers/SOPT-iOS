//
//  SoptletterTopicListEntity.swift
//  Networks
//
//  Created by 최주리 on 7/3/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct SoptletterTopicListEntity: Decodable {
    public let topics: [SoptletterTopicEntity]
}

public struct SoptletterTopicEntity: Decodable {
    public let topicId: Int
    public let title: String
    public let isDefault: Bool
    public let createdAt: String
}
