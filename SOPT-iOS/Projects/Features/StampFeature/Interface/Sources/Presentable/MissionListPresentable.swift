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

public protocol LegacyMissionListViewControllable: LegacyViewControllable & MissionListCoordinatable { }
public protocol MissionListCoordinatable {
  var onSwiped: (() -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
  var onPartRankingButtonTap: ((RankingViewType) -> Void)? { get set }
  var onCurrentGenerationRankingButtonTap: ((RankingViewType) -> Void)? { get set }
  var onGuideTap: (() -> Void)? { get set }
  var onCellTap: ((MissionListModel, _ username: String?) -> Void)? { get set }
  var onReportButtonTap: (() -> Void)? { get set }
}
public typealias MissionListViewModelType = ViewModelType & MissionListCoordinatable
public typealias MissionListPresentable = (vc: UIViewController, vm: any MissionListViewModelType)
