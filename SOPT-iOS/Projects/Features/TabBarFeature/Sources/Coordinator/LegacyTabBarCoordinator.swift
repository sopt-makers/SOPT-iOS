//
//  LegacyTabBarCoordinator.swift
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

public final class LegacyTabBarCoordinator: DefaultTabBarCoordinator {
    
    public var finishFlow: (() -> Void)?
    public var requestCoordinating: ((TabBarCoordinatorDestination) -> Void)?
        
    private let factory: TabBarPresentable
    private let router: LegacyRouter
    private let items: [UIViewController]
    
    public init(router: LegacyRouter, factory: TabBarPresentable, items: [UIViewController]) {
        self.router = router
        self.factory = factory
        self.items = items
    }
    
    public override func start() {
        showTabBar()
    }
    
    private func showTabBar() {
        var tabBar = factory
                
        tabBar.vm.onTabBarItemTapped = { [weak self] tabType in
            // 각 탭의 코디네이터 실행
            switch tabType {
            case .home:
                self?.requestCoordinating?(.home)
            case .soptlog:
                self?.requestCoordinating?(.soptlog)
            default:
                return
            }
        }
        
        tabBar.vm.showTabBarAlert = { [weak self] in
            AlertUtils.presentAlertVC(
                type: .titleDescription,
                title: I18N.Home.PopUp.needToLogin,
                description: I18N.Home.PopUp.needToLoginDetail,
                customButtonTitle: I18N.Home.PopUp.login,
                customAction: { [weak self] in
                    self?.requestCoordinating?(.signIn)
                },
                cancelAction: { [weak self] in
                    self?.requestCoordinating?(.home)
                }
            )
        }
        
        router.replaceRootWindow(tabBar.vc, withAnimation: true, hideBar: true)
    }
}
