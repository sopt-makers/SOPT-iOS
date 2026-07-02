//
//  SoptletterTopicTransform.swift
//  Data
//
//  Created by 최주리 on 7/3/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Domain
import Networks

extension SoptletterTopicListEntity {
    func toDomain() -> SoptletterTopicListModel {
        .init(topics: topics.map { $0.toDomain() })
    }
}

extension SoptletterTopicEntity {
    func toDomain() -> SoptletterTopicModel {
        .init(
            topicId: topicId,
            title: title,
            isDefault: isDefault,
            createdAt: createdAt
        )
    }
}
