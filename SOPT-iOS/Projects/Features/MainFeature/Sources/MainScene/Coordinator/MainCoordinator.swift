//
//  MainCoordinator.swift
//  MainFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core

public
final class MainCoordinator: DefaultCoordinator {
    
    public var finishFlow: (() -> Void)?
    
    private let factory: MainFeatureViewBuildable
    private let router: Router
    private let userType: UserType
    
    public init(router: Router, factory: MainFeatureViewBuildable, userType: UserType) {
        self.factory = factory
        self.router = router
        self.userType = userType
    }
    
    public override func start() {
        let main = factory.makeMain(userType: userType)
        router.setRootWindow(module: main.vc, withAnimation: true)
    }
}
