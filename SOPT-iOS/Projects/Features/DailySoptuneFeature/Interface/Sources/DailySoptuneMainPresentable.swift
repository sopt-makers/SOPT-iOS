//
//  DailySoptuneMainPresentable.swift
//  DailySoptuneFeatureInterface
//
//  Created by 강윤서 on 9/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol DailySoptuneMainViewControllable: ViewControllable {}

public protocol DailySoptuneMainCoordinatable {
    var onNaviBackTap: (() -> Void)? { get set }
    var onReciveTodayFortuneButtonTap: ((DailySoptuneResultModel) -> Void)? { get set }
}

public typealias DailySoptuneMainViewModelType = ViewModelType & DailySoptuneMainCoordinatable
public typealias DailySoptuneMainPresentable = (vc: DailySoptuneMainViewControllable, vm: any DailySoptuneMainViewModelType)
