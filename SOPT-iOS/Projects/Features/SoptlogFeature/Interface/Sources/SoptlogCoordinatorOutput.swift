//
//  SoptlogCoordinatorOutput.swift
//  SoptlogFeatureInterface
//
//  Created by Jae Hyun Lee on 5/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency

public protocol SoptlogCoordinatorOutput: CoordinatorFinishOutput {
    var requestCoordinating: ((SoptlogCoordinatorDestination) -> Void)? { get set }
    var rootViewController: UIViewController? { get }
}

public typealias DefaultSoptlogCoordinator = BaseCoordinator & SoptlogCoordinatorOutput
