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
import Core

public struct PokeDeepLink: DeepLinkExecutable {
    public let name = "poke"
    public let children: [DeepLinkExecutable] = [PokeNotificationListDeepLink()]
    public var isDestination: Bool = false

    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }
        
        let userType = UserDefaultKeyList.Auth.getUserType()
        coordinator.tabBarController?.selectedIndex = TabBarItemType.poke.getTabIndex(userType: userType)
        
        if self.isDestination == true {
            return coordinator
        }
                
        return coordinator.runPokeFlow()
    }
}
