//
//  AuthCoordnatorFinishOutput.swift
//  AuthFeatureInterface
//
//  Created by 장석우 on 7/12/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import Core

public protocol AuthCoordinatorFinishOutput {
    var finishFlow: ((UserType) -> Void)? { get set }
}

public typealias DefaultAuthCoordinator = BaseCoordinator & AuthCoordinatorFinishOutput
