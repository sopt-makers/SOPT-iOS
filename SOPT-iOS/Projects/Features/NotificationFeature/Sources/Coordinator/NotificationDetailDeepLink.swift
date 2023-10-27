//
//  NotificationDetailDeeplink.swift
//  NotificationFeature
//
//  Created by sejin on 2023/10/27.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public struct NotificationDetailDeepLink: DeepLinkable {
    public init() {}
    
    public func execute(with coordinator: Coordinator, components: DeepLinkComponents) {
        guard let coordinator = coordinator as? NotificationCoordinator else { return }
        guard let id = components.getQueryItemValue(name: "id"),
              let notificationId = Int(id) else { return }
        
        coordinator.showNotificationDetail(notificationId: notificationId)
    }
}
