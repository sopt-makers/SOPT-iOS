//
//  DailySoptuneMainPresentable.swift
//  DailySoptuneFeatureInterface
//
//  Created by 강윤서 on 9/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core

public protocol DailySoptuneMainViewControllable: ViewControllable {}

public protocol DailySoptuneMainCoordinatable {}

public typealias DailySoptuneMainViewModelType = ViewModelType & DailySoptuneMainCoordinatable
public typealias DailySoptuneMainPresentable = (vc: DailySoptuneMainViewControllable, vm: any DailySoptuneMainViewModelType)
