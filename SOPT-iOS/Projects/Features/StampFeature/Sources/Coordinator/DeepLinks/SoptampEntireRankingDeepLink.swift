//
//  SoptampEntireRankingDeepLink.swift
//  StampFeature
//
//  Created by sejin on 2023/10/28.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Core

public struct SoptampEntireRankingDeepLink: DeepLinkExecutable {
    public let name = "entire-ranking"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        switch Config.coordinatorFlag {
        case .legacy:
            guard let coordinator = coordinator as? LegacyStampCoordinator else { return nil }
            coordinator.runRankingFlow(rankingViewType: .all)
        case .new:
            guard let coordinator = coordinator as? StampCoordinator else { return nil }
            coordinator.runRankingFlow(rankingViewType: .all)
        }
        
        return coordinator
    }
}

