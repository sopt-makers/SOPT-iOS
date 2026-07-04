//
//  SoptletterTopicEntity.swift
//  Networks
//
//  Created by 최주리 on 7/3/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct SoptletterTopicDetailEntity: Decodable {
    public let topicId: Int
    public let title: String
    public let active: Bool
    public let startedAt: String
    public let endedAt: String
    public let createdAt: String
}
