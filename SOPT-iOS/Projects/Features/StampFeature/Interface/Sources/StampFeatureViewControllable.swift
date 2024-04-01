//
//  StampFeatureViewControllable.swift
//  StampFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency
import Domain

public protocol MissionListViewControllable: ViewControllable & MissionListCoordinatable { }
public protocol MissionListCoordinatable {
    var onSwiped: (() -> Void)? { get set }
    var onNaviBackTap: (() -> Void)? { get set }
    var onPartRankingButtonTap: ((RankingViewType) -> Void)? { get set }
    var onCurrentGenerationRankingButtonTap: ((RankingViewType) -> Void)? { get set }
    var onGuideTap: (() -> Void)? { get set }
    var onCellTap: ((MissionListModel, _ username: String?) -> Void)? { get set }
}
public protocol ListDetailViewControllable: ViewControllable & ListDetailCoordinatable { }
public protocol ListDetailCoordinatable {
    var onComplete: ((StarViewLevel, (() -> Void)?) -> Void)? { get set }
}
public protocol MissionCompletedViewControllable: ViewControllable { }
public protocol RankingViewControllable: ViewControllable & RankingCoordinatable { }
public protocol RankingCoordinatable {
    var onCellTap: ((_ username: String, _ sentence: String) -> Void)? { get set }
    var onNaviBackTap: (() -> Void)? { get set }
}
public protocol PartRankingViewControllable: ViewControllable & RankingCoordinatable { }
public protocol StampGuideViewControllable: ViewControllable { }
