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

public struct SoptampCurrentGenerationRankingDeepLink: DeepLinkExecutable {
    public let name = "current-generation-ranking"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? StampCoordinator else { return nil }
        
        guard let currentGenerationValue = queryItems?.getQueryValue(key: "currentGeneration"),
              let currentGeneration = Int(currentGenerationValue),
              let status = queryItems?.getQueryValue(key: "status")?.uppercased(),
              let userStatus = UsersActivationState(rawValue: status)
        else {
            return nil
        }
        
        let usersActiveGenerationStatus = UsersActiveGenerationStatusViewResponse(currentGeneration: currentGeneration, status: userStatus)
        
        coordinator.runRankingFlow(rankingViewType: .currentGeneration(info: usersActiveGenerationStatus))
        
        return coordinator
    }
}
