//
//  DailySoptuneCoordinatorOutput.swift
//  DailySoptuneFeature
//
//  Created by 강윤서 on 6/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency

public protocol DailySoptuneCoordinatorOutput {
    var requestCoordinating: (() -> Void)? { get set }
    var finishFlow: (() -> Void)? { get set }
}

public typealias DefaultDailySoptuneCoordinator = BaseCoordinator & DailySoptuneCoordinatorOutput
