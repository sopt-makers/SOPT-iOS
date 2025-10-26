//
//  SoptampEntirePartRankingDeepLink.swift
//  StampFeature
//
//  Created by 성현주 on 10/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//


import Foundation
import BaseFeatureDependency
import Core

public struct SoptampEntirePartRankingDeepLink: DeepLinkExecutable {
    public let name = "entire-part-ranking"
    public let children: [DeepLinkExecutable] = [SoptampPartRankingDeepLink()]
    public var isDestination: Bool = false

    public init() {}

    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        switch Config.coordinatorFlag {
        case .legacy:
            guard let coordinator = coordinator as? LegacyStampCoordinator else { return nil }
            coordinator.runRankingFlow(rankingViewType: .partRanking)
        case .new:
            guard let coordinator = coordinator as? StampCoordinator else { return nil }
            coordinator.runRankingFlow(rankingViewType: .partRanking)
        }
        return coordinator
    }
}
