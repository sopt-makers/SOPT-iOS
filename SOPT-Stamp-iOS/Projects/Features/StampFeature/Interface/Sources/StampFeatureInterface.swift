//
//  StampFeatureInterface.swift
//  StampFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency

public protocol StampFeatureInterface: BaseFeatureInterface { }

public protocol StampFeature {
    func makeMissionListVC(sceneType: MissionListSceneType) -> StampFeatureInterface
//    func makeListDetailVC(sceneType: ListDetailSceneType, starLevel: StarViewLevel, missionId: Int, missionTitle: String, otherUserId: Int?) -> StampFeatureInterface
//    func makeMissionCompletedVC(starLevel: StarViewLevel) -> StampFeatureInterface
//    func makeRankingVC() -> StampFeatureInterface
}
