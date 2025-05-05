//
//  TabBarCoordinator.swift
//  TabBarFeature
//
//  Created by Jae Hyun Lee on 5/4/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain

import BaseFeatureDependency
import TabBarFeatureInterface
import WebFeature

public enum TabType: Int {
    case home = 0
    case soptlog = 1
}

public final class TabBarCoordinator: DefaultTabBarCoordinator {
    
    // MARK: - Properties
    
    public var finishFlow: (() -> Void)?
    public var requestCoordinating: ((TabBarCoordinatorDestination) -> Void)?
        
    private let factory: TabBarPresentable
    private var navigationController: UINavigationController
    private let items: [UIViewController]
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: TabBarPresentable,
        items: [UIViewController]
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.items = items
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showTabBar()
    }
    
    // MARK: - Navigation
    
    private func showTabBar() {
        var tabBar = factory
    
        tabBar.vm.onTabBarItemTapped = { [weak self] index in
            // 각 탭의 코디네이터 실행
            guard let tabType = TabType(rawValue: index) else { return }
            switch tabType {
            case .home: self?.requestCoordinating?(.home)
            case .soptlog: self?.requestCoordinating?(.soptlog)
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
                }
            )
        }
        
        tabBar.vm.onFABMenuTapped = { [weak self] url in
            guard let url = URL(string: url) else { return }
            let webView = SOPTWebView(startWith: url)
            self?.navigationController.pushViewController(webView, animated: true)
        }
        
        let navigation = UINavigationController(rootViewController: tabBar.vc)
        CoordinatorUtils.replaceAsRootWindow(root: navigation, hideBar: true)
        self.navigationController = navigation
    }
}
