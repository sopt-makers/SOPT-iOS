//
//  HomeDeeplink.swift
//  RootFeatureDemo
//
//  Created by sejin on 2023/10/27.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public struct HomeDeeplink: Deeplinkable {
    public func execute(with coordinator: Coordinator, components: DeepLinkComponents) {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return }
        if components.isEmpty { // MainFlow(홈 뷰)가 실행되는 경우는 다음 도착지 뷰가 없는 경우이다.
            coordinator.runMainFlow()
        }
        components.execute(coordinator: coordinator)
    }
}
