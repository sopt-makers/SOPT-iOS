//
//  SoptletterTopicDetailTransform.swift
//  Data
//
//  Created by 최주리 on 7/3/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Domain
import Networks

extension SoptletterTopicDetailEntity {
    func toDomain() -> SoptletterTopicDetailModel {
        .init(
            topicId: topicId,
            title: title,
            active: active,
            startedAt: startedAt,
            endedAt: endedAt,
            createdAt: createdAt
        )
    }
}
