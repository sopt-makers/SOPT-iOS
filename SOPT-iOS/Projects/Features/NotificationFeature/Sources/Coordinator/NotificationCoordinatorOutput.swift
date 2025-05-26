//
//  NotificationCoordinatorOutput.swift
//  NotificationFeature
//
//  Created by Jae Hyun Lee on 5/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol NotificationCoordinatorOutput: CoordinatorFinishOutput {
    var requestCoordinating: ((NotificationCoordinatorDestination) -> Void)? { get set }
}

public typealias DefaultNotificationCoordinator = BaseCoordinator & NotificationCoordinatorOutput
