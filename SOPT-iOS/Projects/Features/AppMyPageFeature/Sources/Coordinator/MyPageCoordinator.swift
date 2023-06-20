//
//  MyPageCoordinator.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency
import AppMyPageFeatureInterface

public
final class MyPageCoordinator: DefaultCoordinator {
    
    public var finishFlow: (() -> Void)?
    
    private let factory: MyPageFeatureBuildable
    private let router: Router
    private let userType: UserType
    
    public init(router: Router, factory: MyPageFeatureBuildable, userType: UserType) {
        self.factory = factory
        self.router = router
        self.userType = userType
    }
    
    public override func start() {
        var myPage = factory.makeAppMyPage(userType: userType)
        myPage.vm.onNaviBackButtonTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        router.push(myPage.vc)
    }
}
