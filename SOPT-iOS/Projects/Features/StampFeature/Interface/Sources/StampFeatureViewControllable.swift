//
//  StampFeatureViewControllable.swift
//  StampFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import Domain

public protocol LegacyMissionListViewControllable: LegacyViewControllable & MissionListCoordinatable { }
public protocol MissionListViewControllable: UIViewController & MissionListCoordinatable { }
public protocol MissionListCoordinatable {
  var onSwiped: (() -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
  var onPartRankingButtonTap: ((RankingViewType) -> Void)? { get set }
  var onCurrentGenerationRankingButtonTap: ((RankingViewType) -> Void)? { get set }
  var onGuideTap: (() -> Void)? { get set }
  var onCellTap: ((MissionListModel, _ username: String?) -> Void)? { get set }
  var onReportButtonTap: (() -> Void)? { get set }
}

public protocol LegacyListDetailViewControllable: LegacyViewControllable & ListDetailCoordinatable { }
public protocol ListDetailViewControllable: UIViewController & ListDetailCoordinatable { }
public protocol ListDetailCoordinatable {
  var onComplete: ((StarViewLevel, (() -> Void)?) -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
}

public protocol LegacyMissionCompletedViewControllable: LegacyViewControllable { }
public protocol MissionCompletedViewControllable: UIViewController { }

public protocol LegacyRankingViewControllable: LegacyViewControllable & RankingCoordinatable { }
public protocol RankingViewControllable: UIViewController & RankingCoordinatable { }
public protocol RankingCoordinatable {
  var onCellTap: ((_ username: String, _ sentence: String) -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
}

public protocol LegacyPartRankingViewControllable: LegacyViewControllable & PartRankingCoordinatable { }
public protocol PartRankingViewControllable: UIViewController & PartRankingCoordinatable { }
public protocol PartRankingCoordinatable {
  var onCellTap: ((_ part: Part) -> Void)? { get set }
  var onNaviBackTap: (() -> Void)? { get set }
}

public protocol LegacyStampGuideViewControllable: LegacyViewControllable {
    var onNaviBackTap: (() -> Void)? { get set }
}
public protocol StampGuideViewControllable: UIViewController {
    var onNaviBackTap: (() -> Void)? { get set }
}
