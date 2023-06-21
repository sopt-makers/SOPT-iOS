//
//  StampFeatureBuildable.swift
//  StampFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency

public protocol StampFeatureViewBuildable {
    func makeMissionListVC(sceneType: MissionListSceneType) -> MissionListViewControllable
    func makeListDetailVC(
        sceneType: ListDetailSceneType,
        starLevel: StarViewLevel,
        missionId: Int,
        missionTitle: String,
        otherUserName: String?
    ) -> ListDetailViewControllable
    func makeMissionCompletedVC(starLevel: StarViewLevel, completionHandler: (() -> Void)?) -> MissionCompletedViewControllable
    func makeRankingVC() -> RankingViewControllable
    func makeStampGuideVC() -> StampGuideViewControllable
}
