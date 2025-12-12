//
//  PokeDeepLink.swift
//  RootFeature
//
//  Created by sejin on 12/30/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import PokeFeature

public struct PokeDeepLink: DeepLinkExecutable {
    public let name = "poke"
    public let children: [DeepLinkExecutable] = [PokeNotificationListDeepLink()]
    public var isDestination: Bool = false

    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }
        
        if self.isDestination == true {
            coordinator.runTabBarFlow(initSelectedTabType: .poke)
            return coordinator
        }
        
        return coordinator.runPokeFlow(isRouteFromTabBar: false)
    }
}
