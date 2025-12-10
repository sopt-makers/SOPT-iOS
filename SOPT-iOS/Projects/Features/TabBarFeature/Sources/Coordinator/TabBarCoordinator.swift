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

public protocol TabBarCoordinatorDelegate: AnyObject {
    func tabBarCoordinator(_ coordinator: TabBarCoordinator, to destination: TabBarCoordinatorDestination)
}

public final class TabBarCoordinator: BaseCoordinator {
    
    // MARK: - Properties

    public var requestCoordinating: ((TabBarCoordinatorDestination) -> Void)?
    public weak var delegate: TabBarCoordinatorDelegate?
    public private(set) weak var tabBarController: UITabBarController?
        
    private let factory: TabBarBuilder
    private weak var navigationController: UINavigationController?
    private let views: [UIViewController]
    private let userType: UserType
    private let selectedTabType: TabType
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: TabBarBuilder,
        views: [UIViewController],
        userType: UserType,
        selectedTabType: TabType = .home
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.views = views
        self.userType = userType
        self.selectedTabType = selectedTabType
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        if let existingTabBar = navigationController?.viewControllers.first as? UITabBarController {
            let tabIndex = getTabIndex(for: selectedTabType)
            existingTabBar.selectedIndex = tabIndex
        } else {
            showTabBar()
        }
    }
    
    // MARK: - Navigation
    
    private func showTabBar() {
        var tabBar = factory.makeTabBar(with: views, userType: userType, coordinator: self)

        tabBar.vm.onTabBarItemTapped = { [weak self] index in
            // 각 탭의 코디네이터 실행
            guard let self = self,
                let tabType = TabType(rawValue: index) else { return }
            switch tabType {
            case .home:
                self.delegate?.tabBarCoordinator(self, to: .home)
            case .poke:
                self.delegate?.tabBarCoordinator(self, to: .poke)
            case .soptamp:
                self.delegate?.tabBarCoordinator(self, to: .soptamp)
            case .soptlog:
                self.delegate?.tabBarCoordinator(self, to: .soptlog)
            }
        }
        
        tabBar.vm.showTabBarAlert = { [weak self] in
            AlertUtils.presentAlertVC(
                type: .titleDescription,
                title: I18N.Home.PopUp.needToLogin,
                description: I18N.Home.PopUp.needToLoginDetail,
                customButtonTitle: I18N.Home.PopUp.login,
                customAction: { [weak self] in
                    guard let self else { return }
                    self.delegate?.tabBarCoordinator(self, to: .signIn)
                }
            )
        }
        
        tabBar.vm.onFABMenuTapped = { [weak self] url in
            guard let url = URL(string: url) else { return }
            let webView = SOPTWebView(startWith: url)
            self?.navigationController?.pushViewController(webView, animated: true)
        }
        
//<<<<<<< HEAD
        let tabIndex = getTabIndex(for: selectedTabType)
        tabBar.vc.selectedIndex = tabIndex
        
//=======
        self.tabBarController = tabBar.vc
//>>>>>>> develop
        self.navigationController?.setViewControllers([tabBar.vc], animated: false)
    }
    
    private func getTabIndex(for tabType: TabType) -> Int {
        switch userType {
        case .active:
            switch tabType {
            case .home:
                0
            case .soptstamp:
                1
            case .poke:
                2
            case .soptlog:
                3
            }
        case .visitor, .inactive:
            switch tabType {
            case .home, .soptstamp:
                0
            case .poke:
                1
            case .soptlog:
                2
            }
        }
    }
}

