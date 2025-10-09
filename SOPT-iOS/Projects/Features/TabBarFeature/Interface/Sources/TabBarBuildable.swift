//
//  TabBarBuildable.swift
//  TabBarFeatureDemo
//
//  Created by 강윤서 on 2/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Core
import BaseFeatureDependency

public protocol TabBarBuildable {
    func makeTabBar(with views: [UIViewController], userType: UserType, coordinator: Coordinator) -> TabBarPresentable
}
