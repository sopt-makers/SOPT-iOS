//
//  TabBarCoordinator.swift
//  TabBarFeature
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
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
    
    public var finishFlow: (() -> Void)?
    public var requestCoordinating: ((TabBarCoordinatorDestination) -> Void)?
        
    private let factory: TabBarBuildable
    private let router: Router
    private let items: [UIViewController]
    
    public init(router: Router, factory: TabBarBuildable, items: [UIViewController]) {
        self.router = router
        self.factory = factory
        self.items = items
    }
    
    public override func start() {
        showTabBar()
    }
    
    private func showTabBar() {
        var tabBar = factory.makeTabBar(with: items)
        
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
