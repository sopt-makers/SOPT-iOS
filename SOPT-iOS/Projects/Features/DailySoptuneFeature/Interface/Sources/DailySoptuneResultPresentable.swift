//
//  DailySoptuneResultPresentable.swift
//  DailySoptuneFeatureInterface
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol DailySoptuneResultViewControllable: ViewControllable { }

public protocol DailySoptuneResultCoordinatable {
}

public typealias DailySoptuneResultViewModelType = ViewModelType & DailySoptuneResultCoordinatable
public typealias DailySoptuneResultPresentable = (vc: DailySoptuneResultViewControllable, vm: any DailySoptuneResultViewModelType)
