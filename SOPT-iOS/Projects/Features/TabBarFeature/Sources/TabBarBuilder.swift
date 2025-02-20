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
    public func makeTabBar() -> TabBarPresentable {
        let viewModel = TabBarViewModel()
        let tabBarVC = TabBarController(viewModel: viewModel, tabList: [])
        return (tabBarVC, viewModel)
    }
}
