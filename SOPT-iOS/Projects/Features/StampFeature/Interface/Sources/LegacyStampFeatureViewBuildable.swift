//
//  LegacyStampFeatureViewBuildable.swift
//  StampFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency

public protocol LegacyStampFeatureViewBuildable {
    func makeMissionListVC(sceneType: MissionListSceneType) -> LegacyMissionListViewControllable
    func makeListDetailVC(
        sceneType: ListDetailSceneType,
        starLevel: StarViewLevel,
        missionId: Int,
        missionTitle: String,
        otherUserName: String?
    ) -> LegacyListDetailViewControllable
    func makeMissionCompletedVC(
        starLevel: StarViewLevel,
        completionHandler: (() -> Void)?
    ) -> LegacyMissionCompletedViewControllable
    func makeRankingVC(rankingViewType: RankingViewType) -> LegacyRankingViewControllable
    func makePartRankingVC(rankingViewType: RankingViewType) -> LegacyPartRankingViewControllable
    func makeStampGuideVC() -> LegacyStampGuideViewControllable
}
