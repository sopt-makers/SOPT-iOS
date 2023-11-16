//
//  NotificationDetailDeeplink.swift
//  NotificationFeature
//
//  Created by sejin on 2023/10/27.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public struct NotificationDetailDeepLink: DeepLinkExecutable {
    public let name = "detail"
    public let children: [DeepLinkExecutable] = []
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? NotificationCoordinator else { return nil }
        guard let id = queryItems?.getQueryValue(key: "id"),
              let notificationId = Int(id) else { return nil }
        
        coordinator.showNotificationDetail(notificationId: notificationId)
        
        return nil
    }
}
