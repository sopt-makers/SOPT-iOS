//
//  HomeDeeplink.swift
//  RootFeatureDemo
//
//  Created by sejin on 2023/10/27.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public struct HomeDeepLink: DeepLinkExecutable {
    public let name = "home"
    public let children: [DeepLinkExecutable] = [NotificationDeepLink(), SoptampDeepLink(), MyPageDeepLink(), AttendanceDeepLink()]
    
    public func execute(with coordinator: Coordinator, components: DeepLinkComponentsExecutable) {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return }
        
        // runMainFlow가 실행되는 경우는 딥링크로 연결할 다음 뷰가 없는 경우이다.
        // (deepLink == "home" 인 경우)
        if components.isEmpty {
            coordinator.runMainFlow()
        }
        
        components.execute(coordinator: coordinator)
    }
}
