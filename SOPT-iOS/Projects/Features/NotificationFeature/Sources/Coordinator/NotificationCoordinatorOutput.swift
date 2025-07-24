//
//  NotificationCoordinatorOutput.swift
//  NotificationFeature
//
//  Created by Jae Hyun Lee on 5/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

// TODO: - Legacy 제거 시 함께 제거
public protocol NotificationCoordinatorOutput: CoordinatorFinishOutput {
    var requestCoordinating: ((NotificationCoordinatorDestination) -> Void)? { get set }
}

public typealias DefaultNotificationCoordinator = BaseCoordinator & NotificationCoordinatorOutput
