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
public protocol RankingViewControllable: UIViewController & RankingCoordinatable { }
public protocol RankingCoordinatable {
  var onCellTap: ((_ username: String, _ sentence: String) -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
}
public typealias RankingViewModelType = ViewModelType & RankingCoordinatable
// TODO: coordinating vc -> vm 작업에서 활용
public typealias RankingPresentable = (vc: RankingViewControllable, vm: any RankingViewModelType)

