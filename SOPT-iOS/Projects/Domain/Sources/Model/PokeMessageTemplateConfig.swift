//
//  PokeMessageTemplateConfig.swift
//  Domain
//
//  Created by a on 5/13/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct PokeMessageTemplateConfig {
    public let isAnonymousSelectionAvailable: Bool
    
    public init(isAnonymousSelectionAvailable: Bool) {
        self.isAnonymousSelectionAvailable = isAnonymousSelectionAvailable
    }
}
