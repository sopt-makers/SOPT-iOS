//
//  SoptampPartRankingDeepLink.swift
//  StampFeature
//
//  Created by 성현주 on 10/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//


import Foundation
import BaseFeatureDependency
import Core

public struct SoptampPartRankingDeepLink: DeepLinkExecutable {
    public let name = "part-ranking"
    public let children: [DeepLinkExecutable] = [SoptampPartMissionListDeepLink()]
    public var isDestination: Bool = false

    public init() {}

    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {

        guard let partString = queryItems?.getQueryValue(key: "part") else {
            return coordinator
        }

        guard let part = Part.allCases.first(where: {
            $0.uppercasedName() == partString.uppercased()
        }) else {
            print("[DeepLink][Soptamp][Error] Invalid part parameter: \(partString)")
            return coordinator
        }

        switch Config.coordinatorFlag {
        case .legacy:
            guard let coordinator = coordinator as? LegacyStampCoordinator else { return nil }
            coordinator.runRankingFlow(rankingViewType: .individualRankingInPart(part: part))
        case .new:
            guard let coordinator = coordinator as? StampCoordinator else { return nil }
            coordinator.runRankingFlow(rankingViewType: .individualRankingInPart(part: part))
        }

        return coordinator
    }
}
