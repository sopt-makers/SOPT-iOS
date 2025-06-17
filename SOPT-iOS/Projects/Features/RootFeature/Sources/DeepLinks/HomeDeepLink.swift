//
//  HomeDeeplink.swift
//  RootFeatureDemo
//
//  Created by sejin on 2023/10/27.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import Core

public struct HomeDeepLink: DeepLinkExecutable {
    public let name = "home"
    public let children: [DeepLinkExecutable] = [NotificationDeepLink(), SoptampDeepLink(), MyPageDeepLink(), AttendanceDeepLink(), PokeDeepLink(), DailySoptuneDeepLink()]
    public var isDestination: Bool = false
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }
        
        if self.isDestination == true {
            Config.coordinatorFlag == .legacy ? coordinator.runLegacyTabBarFlow(initSelectedTabIndex: 0) : coordinator.runTabBarFlow(initSelectedTabType: .home)
        }
        
        return coordinator
    }
}
