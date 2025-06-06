//
//  LegacyStampGuideCoordinator.swift
//  StampFeature
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency
import StampFeatureInterface

public
final class LegacyStampGuideCoordinator: DefaultCoordinator {
        
    public var finishFlow: (() -> Void)?
    
    private let factory: LegacyStampFeatureViewBuildable
    private let router: LegacyRouter
    
    public init(router: LegacyRouter, factory: LegacyStampFeatureViewBuildable) {
        self.factory = factory
        self.router = router
    }
    
    public override func start() {
        showGuide()
    }
    
    private func showGuide() {
        var guide = factory.makeStampGuideVC()
        
        guide.onNaviBackTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        
        router.push(guide)
    }
}
