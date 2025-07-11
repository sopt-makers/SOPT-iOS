//
//  MissionListPresentable.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import Domain

public protocol LegacyMissionListViewControllable: LegacyViewControllable & MissionListRoutingTrigger { }
public protocol MissionListViewControllable: UIViewController & MissionListRoutingTrigger { }

public protocol MissionListRoutingTrigger {
  var onSwiped: (() -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
  var onPartRankingButtonTap: ((RankingViewType) -> Void)? { get set }
  var onCurrentGenerationRankingButtonTap: ((RankingViewType) -> Void)? { get set }
  var onGuideTap: (() -> Void)? { get set }
  var onCellTap: ((MissionListModel, _ username: String?) -> Void)? { get set }
  var onReportButtonTap: (() -> Void)? { get set }
}
// TODO: coordinating vc -> vm 작업에서 활용
public typealias MissionListViewModelType = ViewModelType & MissionListRoutingTrigger
public typealias MissionListPresentable = (vc: any MissionListViewControllable, vm: any MissionListViewModelType)
