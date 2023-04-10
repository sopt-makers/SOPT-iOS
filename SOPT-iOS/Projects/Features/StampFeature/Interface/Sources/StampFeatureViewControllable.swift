//
//  StampFeatureViewControllable.swift
//  StampFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency

public protocol MissionListViewControllable: ViewControllable { }

public protocol ListDetailViewControllable: ViewControllable { }

public protocol MissionCompletedViewControllable: ViewControllable { }

public protocol RankingViewControllable: ViewControllable { }

public protocol StampGuideViewControllable: ViewControllable { }

public protocol StampFeatureViewBuildable {
    func makeMissionListVC(sceneType: MissionListSceneType) -> MissionListViewControllable
    func makeListDetailVC(sceneType: ListDetailSceneType,
                          starLevel: StarViewLevel,
                          missionId: Int,
                          missionTitle: String,
                          otherUserId: Int?) -> ListDetailViewControllable
    func makeMissionCompletedVC(starLevel: StarViewLevel, completionHandler: (() -> Void)?) -> MissionCompletedViewControllable
    func makeRankingVC() -> RankingViewControllable
    func makeStampGuideVC() -> StampGuideViewControllable
}
