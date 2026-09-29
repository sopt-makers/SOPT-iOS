//
//  PartRankingPresentable.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import Domain

public protocol PartRankingViewControllable: ViewControllable { }
public protocol PartRankingRoutingTrigger {
    var onCellTap: ((_ part: Part) -> Void)? { get set }
    var onNaviBackTap: (() -> Void)? { get set }
    var onRightButtonTap: (() -> Void)? { get set }
}
public typealias PartRankingViewModelType = ViewModelType & PartRankingRoutingTrigger

public typealias PartRankingPresentable = (vc: UIViewController, vm: any PartRankingViewModelType)
