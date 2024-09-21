//
//  DailySoptunePresentable.swift
//  DailySoptuneFeatureInterface
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol DailySoptuneViewControllable: ViewControllable { }

public protocol DailySoptuneCoordinatable {
}

public typealias DailySoptuneViewModelType = ViewModelType & DailySoptuneCoordinatable
public typealias DailySoptunePresentable = (vc: DailySoptuneViewControllable, vm: any DailySoptuneViewModelType)
