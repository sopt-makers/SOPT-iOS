//
//  CoordinatorFinishiOutput.swift
//  BaseFeatureDependency
//
//  Created by Junho Lee on 2023/06/03.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

/// Coordinator가 자신의 플로우를 마쳤을 때 호출됩니다. 대개의 경우 removeDependency()가 호출됩니다.
public protocol CoordinatorFinishOutput {
    var finishFlow: (() -> Void)? { get set }
}

public typealias DefaultCoordinator = BaseCoordinator & CoordinatorFinishOutput
