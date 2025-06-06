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

public protocol LegacyPartRankingViewControllable: LegacyViewControllable & PartRankingCoordinatable { }
public protocol PartRankingViewControllable: UIViewController & PartRankingCoordinatable { }
public protocol PartRankingCoordinatable {
  var onCellTap: ((_ part: Part) -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
}
public typealias PartRankingViewModelType = ViewModelType & PartRankingCoordinatable
// TODO: coordinating vc -> vm 작업에서 활용
public typealias PartRankingPresentable = (vc: PartRankingViewControllable, vm: any PartRankingViewModelType)
