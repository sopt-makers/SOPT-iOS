//
//  NotificationDetailDeeplink.swift
//  NotificationFeature
//
//  Created by sejin on 2023/10/27.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Core

public struct NotificationDetailDeepLink: DeepLinkExecutable {
    public let name = "detail"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let notificationId = queryItems?.getQueryValue(key: "id") else { return nil }
        switch Config.coordinatorFlag {
        case .legacy:
            guard let coordinator = coordinator as? LegacyNotificationCoordinator else { return nil }
            coordinator.showNotificationDetail(notificationId: notificationId)
        case .new:
            guard let coordinator = coordinator as? NotificationCoordinator else { return nil }
            coordinator.showNotificationDetail(notificationId: notificationId)
        }
        
        return nil
    }
}
