//
//  SoptampEntireRankingDeepLink.swift
//  StampFeature
//
//  Created by sejin on 2023/10/28.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public struct SoptampEntireRankingDeepLink: DeepLinkExecutable {
    public let name = "entire-ranking"
    public let children: [DeepLinkExecutable] = []
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, components: DeepLinkComponentsExecutable) {
        guard let coordinator = coordinator as? StampCoordinator else { return }
        
        coordinator.runRankingFlow(rankingViewType: .all)
        components.execute(coordinator: coordinator)
    }
}

