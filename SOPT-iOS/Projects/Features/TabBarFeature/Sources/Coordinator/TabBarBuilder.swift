//
//  TabBarBuilder.swift
//  TabBarFeature
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import TabBarFeatureInterface
import UIKit

public final class TabBarBuilder {
    public init() {}
}

extension TabBarBuilder: TabBarBuildable {
    public func makeTabBar(with views: [UIViewController], userType: UserType) -> TabBarPresentable {
        let viewModel = TabBarViewModel(userType: userType)
        let tabBarVC = TabBarController(viewModel: viewModel, tabList: views)
        return (tabBarVC, viewModel)
    }
    
    public func makeTabBarFABMenu() -> UIViewController {
        let tabBarFABMenuVC = TabBarFABMenuVC()
        return tabBarFABMenuVC
    }
}
