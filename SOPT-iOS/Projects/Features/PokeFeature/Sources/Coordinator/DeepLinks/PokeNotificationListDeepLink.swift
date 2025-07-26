//
//  PokeNotificationListDeepLink.swift
//  PokeFeature
//
//  Created by sejin on 12/30/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

// TODO: - Legacy 삭제하면서 Core 제거
import Core

public struct PokeNotificationListDeepLink: DeepLinkExecutable {
    public let name = "notification-list"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        switch Config.coordinatorFlag {
        case .legacy:
            guard let coordinator = coordinator as? LegacyPokeCoordinator else { return nil }
            coordinator.runPokeNotificationListFlow()
        case .new:
            guard let coordinator = coordinator as? PokeCoordinator else { return nil }
            coordinator.runPokeNotificationListFlow()
        }
        
        return nil
    }
}
