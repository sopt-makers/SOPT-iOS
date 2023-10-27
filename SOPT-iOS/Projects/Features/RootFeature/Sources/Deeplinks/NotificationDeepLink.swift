//
//  NotificationDeeplink.swift
//  RootFeatureDemo
//
//  Created by sejin on 2023/10/27.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public struct NotificationDeepLink: DeepLinkExecutable {
    public func execute(with coordinator: Coordinator, components: DeepLinkComponentsExecutable) {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return }
        let notificationCoordinator = coordinator.runNotificationFlow()
        components.execute(coordinator: notificationCoordinator)
    }
}

