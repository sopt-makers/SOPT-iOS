//
//  AppJamRankingViewControllable.swift
//  StampFeature
//
//  Created by 강윤서 on 12/17/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import Domain

// MARK: - ViewControllable

public protocol AppJamRankingViewControllable: UIViewController { }

// MARK: - RoutingTrigger

public protocol AppJamRankingRoutingTrigger {
    var onNaviBackTap: (() -> Void)? { get set }
    var onNetworkError: (@MainActor () -> Void)? { get set }
}

// MARK: - ViewModelType

public typealias AppJamRankingViewModelType = ViewModelType & AppJamRankingRoutingTrigger

// MARK: - Presentable

public typealias AppJamRankingPresentable = (
    vc: any AppJamRankingViewControllable,
    vm: any AppJamRankingViewModelType
)
