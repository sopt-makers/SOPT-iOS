//
//  SoptletterCTAModel.swift
//  Domain
//
//  Created by dev on 7/13/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct SoptletterCTAModel {
    public let showCta: Bool
    public let topicId: Int
    public let ctaText: String
    
    public init(showCta: Bool, topicId: Int, ctaText: String) {
        self.showCta = showCta
        self.topicId = topicId
        self.ctaText = ctaText
    }
}
