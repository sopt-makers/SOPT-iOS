//
//  RankingPresentable.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import Domain

public protocol LegacyRankingViewControllable: LegacyViewControllable & RankingCoordinatable { }
public protocol RankingCoordinatable {
  var onCellTap: ((_ username: String, _ sentence: String) -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
}
public typealias RankingViewModelType = ViewModelType & RankingCoordinatable
public typealias RankingPresentable = (vc: UIViewController, vm: any RankingViewModelType)

