//
//  StampFeatureViewBuildable.swift
//  StampFeatureInterface
//
//  Created by Jae Hyun Lee on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain
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
    func makeMissionCompletedVC(
        starLevel: StarViewLevel,
        completionHandler: (() -> Void)?
    ) -> MissionCompletedViewControllable
    func makeRankingVC(rankingViewType: RankingViewType) -> RankingViewControllable
    func makePartRankingVC(rankingViewType: RankingViewType) -> PartRankingViewControllable
    func makeStampGuideVC() -> StampGuideViewControllable
}
