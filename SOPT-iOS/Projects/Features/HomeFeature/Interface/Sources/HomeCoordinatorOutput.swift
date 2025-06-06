//
//  HomeCoordinatorOutput.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 5/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency

public protocol HomeCoordinatorOutput {
    var requestCoordinating: ((HomeCoordinatorDestination) -> Void)? { get set }
    var rootViewController: UIViewController? { get }
}

public typealias DefaultHomeCoordinator = BaseCoordinator & HomeCoordinatorOutput
