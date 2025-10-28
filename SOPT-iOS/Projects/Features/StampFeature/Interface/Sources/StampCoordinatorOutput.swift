//
//  StampCoordinatorOutput.swift
//  StampFeature
//
//  Created by 최주리 on 10/28/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency

public protocol StampCoordinatorOutput: CoordinatorFinishOutput {
    var requestCoordinating: ((StampCoordinatorDestination) -> Void)? { get set }
    var rootViewController: UIViewController? { get }
}

public typealias DefaultStampCoordinator = BaseCoordinator & StampCoordinatorOutput
