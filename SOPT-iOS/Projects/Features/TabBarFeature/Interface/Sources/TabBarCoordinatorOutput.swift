//
//  TabBarCoordinatorOutput.swift
//  TabBarFeatureInterface
//
//  Created by Jae Hyun Lee on 5/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency

public protocol TabBarCoordinatorOutput: AnyObject {
    var requestCoordinating: ((TabBarCoordinatorDestination) -> Void)? { get set }
}

public typealias DefaultTabBarCoordinator = BaseCoordinator & TabBarCoordinatorOutput
