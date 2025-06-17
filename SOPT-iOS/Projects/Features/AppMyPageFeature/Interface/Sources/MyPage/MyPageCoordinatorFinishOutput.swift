//
//  MyPageCoordinatorFinishOutput.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/4/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol MyPageCoordinatorFinishOutput {
    var finishFlow: (() -> Void)? { get set }
    var requestCoordinating: ((MyPageCoordinatorDestination) -> Void)? { get set }
}

public typealias DefaultMyPageCoordinator = BaseCoordinator & MyPageCoordinatorFinishOutput
