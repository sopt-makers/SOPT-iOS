//
//  StampGuideCoordinator.swift
//  StampFeature
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency
import StampFeatureInterface

public
final class StampGuideCoordinator: DefaultCoordinator {
        
    public var finishFlow: (() -> Void)?
    
    private let factory: StampFeatureViewBuildable
    private let router: Router
    
    public init(router: Router, factory: StampFeatureViewBuildable) {
        self.factory = factory
        self.router = router
    }
    
    public override func start() {
        showGuide()
    }
    
    private func showGuide() {
        let guide = factory.makeStampGuideVC()
        router.push(guide)
    }
}
