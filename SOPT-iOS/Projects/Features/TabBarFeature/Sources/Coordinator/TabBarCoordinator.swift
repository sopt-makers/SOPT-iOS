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

public final class TabBarCoordinator: DefaultTabBarCoordinator {
    
    // MARK: - Properties
    
    public var finishFlow: (() -> Void)?
    public var requestCoordinating: ((TabBarCoordinatorDestination) -> Void)?
    public weak var delegate: TabBarCoordinatorDelegate?
        
    private let factory: TabBarBuilder
    private var navigationController: UINavigationController
    private let views: [UIViewController]
    private let userType: UserType
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: TabBarBuilder,
        views: [UIViewController],
        userType: UserType
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.views = views
        self.userType = userType
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showTabBar()
    }
    
    // MARK: - Navigation
    
    private func showTabBar() {
        var tabBar = factory.makeTabBar(with: views, userType: userType, coordinator: self)

        tabBar.vm.onTabBarItemTapped = { [weak self] index in
            // 각 탭의 코디네이터 실행
            guard let self = self,
                let tabType = TabType(rawValue: index) else { return }
            switch tabType {
            case .home: self.delegate?.tabBarCoordinator(self, to: .home)
            case .soptlog: self.delegate?.tabBarCoordinator(self, to: .soptlog)
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
            self?.navigationController.pushViewController(webView, animated: true)
        }
    }
}
