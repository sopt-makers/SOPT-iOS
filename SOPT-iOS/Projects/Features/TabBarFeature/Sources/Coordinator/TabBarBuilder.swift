//
//  TabBarBuilder.swift
//  TabBarFeature
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency
@_exported import TabBarFeatureInterface

public final class TabBarBuilder {
    @Injected public var homeRepository: HomeRepositoryInterface
    
    public init() {}
}

extension TabBarBuilder: TabBarBuildable {
    public func makeTabBar(with views: [UIViewController], userType: UserType, coordinator: Coordinator) -> TabBarPresentable {
        let homeUseCase = DefaultHomeUseCase(repository: homeRepository)
        let viewModel = TabBarViewModel(userType: userType, coordinator: coordinator, homeUseCase: homeUseCase)
        let tabBarVC = TabBarController(viewModel: viewModel, tabList: views, userType: userType)
        return (tabBarVC, viewModel)
    }
}
