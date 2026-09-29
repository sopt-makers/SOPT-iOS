//
//  SoptampDeepLink.swift
//  RootFeature
//
//  Created by sejin on 2023/10/28.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import StampFeature
import Core

public struct SoptampDeepLink: DeepLinkExecutable {
    public let name = "soptamp"
    public let children: [DeepLinkExecutable] = [SoptampEntireRankingDeepLink(), SoptampCurrentGenerationRankingDeepLink(), SoptampEntirePartRankingDeepLink()]
    public var isDestination: Bool = false

    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }
  
        if let index = TabBarItemType.soptamp.getTabIndex(in: coordinator.activeTabTypes) {
            coordinator.tabBarController?.selectedIndex = index
        }
        
        if self.isDestination == true {
            Task { [weak coordinator] in
                await coordinator?.runTabBarFlow(initSelectedTabType: .soptamp)
            }
        }
        return coordinator.runStampFlow()
    }
}
