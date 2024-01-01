//
//  NotificationDeeplink.swift
//  RootFeatureDemo
//
//  Created by sejin on 2023/10/27.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import NotificationFeature

public struct NotificationDeepLink: DeepLinkExecutable {
    public let name = "notification"
    public let children: [DeepLinkExecutable] = [NotificationDetailDeepLink()]
    public var isDestination: Bool = false
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }
        
        let notificationCoordinator = coordinator.runNotificationFlow()
        return notificationCoordinator
    }
}

