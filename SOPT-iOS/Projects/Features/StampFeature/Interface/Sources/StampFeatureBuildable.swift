//
//  StampFeatureBuildable.swift
//  StampFeatureInterface
//
//  Created by Jae Hyun Lee on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency

public protocol StampFeatureBuildable {
    func makeMissionListVC(sceneType: MissionListSceneType) -> MissionListPresentable
    func makeListDetailVC(
        sceneType: ListDetailSceneType,
        starLevel: StarViewLevel,
        missionId: Int,
        missionTitle: String,
        otherUserName: String?
    ) -> ListDetailPresentable
    func makeMissionCompletedVC(
        starLevel: StarViewLevel,
        completionHandler: (() -> Void)?
    ) -> UIViewController
    func makeRankingVC(rankingViewType: RankingViewType) -> RankingPresentable
    func makePartRankingVC(rankingViewType: RankingViewType) -> PartRankingPresentable
    func makeStampGuideVC() -> StampGuideViewControllable
}
