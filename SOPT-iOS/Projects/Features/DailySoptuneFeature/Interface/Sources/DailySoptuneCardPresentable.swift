//
//  DailySoptuneCardPresentable.swift
//  DailySoptuneFeatureInterface
//
//  Created by Jae Hyun Lee on 9/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core

public protocol DailySoptuneCardViewControllable: ViewControllable { }

public protocol DailySoptuneCardCoordinatable {
    var onGoToHomeButtonTapped: (() -> Void)? { get set }
    var onBackButtonTapped: (() -> Void)? { get set }
}

public typealias DailySoptuneCardViewModelType = ViewModelType & DailySoptuneCardCoordinatable
public typealias DailySoptuneCardPresentable = (vc: DailySoptuneCardViewControllable, vm: any DailySoptuneCardViewModelType)
