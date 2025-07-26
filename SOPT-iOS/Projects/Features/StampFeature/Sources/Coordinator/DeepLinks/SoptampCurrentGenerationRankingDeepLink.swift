//
//  SoptampCurrentGenerationRankingDeepLink.swift
//  StampFeature
//
//  Created by sejin on 2023/11/09.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Domain

// TODO: - Legacy 삭제하면서 Core 제거
import Core

public struct SoptampCurrentGenerationRankingDeepLink: DeepLinkExecutable {
    public let name = "current-generation-ranking"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let currentGenerationValue = queryItems?.getQueryValue(key: "currentGeneration"),
              let currentGeneration = Int(currentGenerationValue),
              let status = queryItems?.getQueryValue(key: "status")?.uppercased(),
              let userStatus = UsersActivationState(rawValue: status)
        else {
            return nil
        }
        
        let usersActiveGenerationStatus = UsersActiveGenerationStatusViewResponse(currentGeneration: currentGeneration, status: userStatus)
        
        switch Config.coordinatorFlag {
        case .legacy:
            guard let coordinator = coordinator as? LegacyStampCoordinator else { return nil }
            coordinator.runRankingFlow(rankingViewType: .currentGeneration(info: usersActiveGenerationStatus))
        case .new:
            guard let coordinator = coordinator as? StampCoordinator else { return nil }
            coordinator.runRankingFlow(rankingViewType: .currentGeneration(info: usersActiveGenerationStatus))
        }
        
        return coordinator
    }
}
