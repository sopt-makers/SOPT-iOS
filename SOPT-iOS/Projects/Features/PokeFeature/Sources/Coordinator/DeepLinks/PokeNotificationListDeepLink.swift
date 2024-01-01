//
//  PokeNotificationListDeepLink.swift
//  PokeFeature
//
//  Created by sejin on 12/30/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public struct PokeNotificationListDeepLink: DeepLinkExecutable {
    public let name = "notification-list"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? PokeCoordinator else { return nil }
        
        coordinator.runPokeNotificationListFlow()
        
        return nil
    }
}
