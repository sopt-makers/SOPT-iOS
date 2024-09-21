//
//  DailySoptuneCoordinator.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency
import DailySoptuneFeatureInterface
import Domain

public final class DailySoptuneCoordinator: DefaultCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let factory: DailySoptuneFeatureBuildable
    private let router: Router
    
    public init(router: Router, factory: DailySoptuneFeatureBuildable) {
        self.router = router
        self.factory = factory
    }
}
