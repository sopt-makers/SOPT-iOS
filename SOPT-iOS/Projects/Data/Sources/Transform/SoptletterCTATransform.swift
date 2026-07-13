//
//  SoptletterCTATransform.swift
//  Data
//
//  Created by dev on 7/13/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Networks
import Domain

extension SoptletterCTAResponse {
    func toDomain() -> SoptletterCTAModel {
        SoptletterCTAModel(
            showCta: showCta,
            topicId: topicId,
            ctaText: ctaText
        )
    }
}
