//
//  AppjamtampDeepLink.swift
//  RootFeature
//
//  Created by Cursor on 2026/01/11.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import StampFeature

public struct AppjamtampDeepLink: DeepLinkExecutable {
    public let name = "appjamtamp"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false

    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }
  
        coordinator.runTabBarFlow(initSelectedTabType: .soptamp)
        return coordinator
    }
}

