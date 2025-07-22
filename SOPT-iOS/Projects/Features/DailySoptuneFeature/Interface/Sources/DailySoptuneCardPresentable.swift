//
//  DailySoptuneCardPresentable.swift
//  DailySoptuneFeatureInterface
//
//  Created by Jae Hyun Lee on 9/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core

public protocol DailySoptuneCardViewControllable: LegacyViewControllable { }

public protocol DailySoptuneCardRoutingTrigger {
    var onGoToHomeButtonTapped: (() -> Void)? { get set }
    var onBackButtonTapped: (() -> Void)? { get set }
}

public typealias DailySoptuneCardViewModelType = ViewModelType & DailySoptuneCardRoutingTrigger
public typealias LegacyDailySoptuneCardPresentable = (vc: DailySoptuneCardViewControllable, vm: any DailySoptuneCardViewModelType)

public typealias DailySoptuneCardPresentable = (vc: UIViewController, vm: any DailySoptuneCardViewModelType)
