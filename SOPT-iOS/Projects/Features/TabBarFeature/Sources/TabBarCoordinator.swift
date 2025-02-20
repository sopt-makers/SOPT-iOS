//
//  TabBarCoordinator.swift
//  TabBarFeature
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Core
import Domain

import BaseFeatureDependency
import TabBarFeatureInterface
import WebFeature

public enum TabBarCoordinatorDestination {
    case home
    case soptlog
}

public final class TabBarCoordinator: DefaultCoordinator {
    
    public var requestCoordinating: ((TabBarCoordinatorDestination) -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: TabBarBuildable
    private let router: Router
    
    public init(router: Router, factory: TabBarBuildable) {
        self.router = router
        self.factory = factory
    }
    
    public override func start() {
        showTabBar()
    }
    
    private func showTabBar() {
        var tabBar = factory.makeTabBar()
        
        tabBar.vm.onTabBarItemTapped = { [weak self] index in
            // 각 탭의 코디네이터 실행
            switch index {
            case 0:
                self?.requestCoordinating?(.home)
            case 1:
                self?.requestCoordinating?(.soptlog)
            default:
                break
            }
        }
        
        self.router.push(tabBar.vc)
    }
}
