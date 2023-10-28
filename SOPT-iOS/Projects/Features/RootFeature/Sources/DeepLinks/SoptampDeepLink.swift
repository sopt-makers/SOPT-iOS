//
//  SoptampDeepLink.swift
//  RootFeature
//
//  Created by sejin on 2023/10/28.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import StampFeature

public struct SoptampDeepLink: DeepLinkExecutable {
    public let name = "soptamp"
    public let children: [DeepLinkExecutable] = [SoptampEntireRankingDeepLink()]
    
    public func execute(with coordinator: Coordinator, components: DeepLinkComponentsExecutable) {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return }
        
        let stampCoordinator = coordinator.runStampFlow()
        components.execute(coordinator: stampCoordinator)
    }
}
