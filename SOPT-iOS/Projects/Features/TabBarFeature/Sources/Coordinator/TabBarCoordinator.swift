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
    private let selectedTabType: TabBarItemType
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: TabBarBuilder,
        views: [UIViewController],
        userType: UserType,
        selectedTabType: TabBarItemType = .home
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
            tabBarController = existingTabBar
            let tabIndex = selectedTabType.getTabIndex(userType: userType)
            existingTabBar.selectedIndex = tabIndex
        } else {
            showTabBar()
        }
    }
    
    // MARK: - Navigation
    
    private func showTabBar() {
        var tabBar = factory.makeTabBar(with: views, userType: userType, coordinator: self)
        
        tabBar.vm.onTabBarItemTapped = { [weak self] tabType in
            // 각 탭의 코디네이터 실행
            guard let self = self else { return }
            
            switch tabType {
            case .home:
                self.delegate?.tabBarCoordinator(self, to: .home)
            case .soptamp:
                self.delegate?.tabBarCoordinator(self, to: .soptamp)
            case .poke:
                self.delegate?.tabBarCoordinator(self, to: .poke)
            case .soptlog:
                self.delegate?.tabBarCoordinator(self, to: .soptlog)
            }
        }
        
        tabBar.vm.onFABMenuTapped = { [weak self] url in
            guard let url = URL(string: url) else { return }
            let webView = SOPTWebView(startWith: url)
            self?.navigationController?.pushViewController(webView, animated: true)
        }
        
        
        tabBar.vm.showTabBarAlert = { [weak self] in
            guard let self = self else { return }
            AlertUtils.presentAlertVC(
                type: .titleDescription,
                title: I18N.Home.PopUp.needToLogin,
                description: I18N.Home.PopUp.needToLoginDetail,
                customButtonTitle: I18N.Home.PopUp.login,
                customAction: { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.tabBarCoordinator(self, to: .signIn)
                },
                cancelAction: { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.tabBarCoordinator(self, to: .home)
                }
            )
        }
        
        self.tabBarController = tabBar.vc
        self.navigationController?.setViewControllers([tabBar.vc], animated: false)
    }
}

