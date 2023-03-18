//
//  StampFeatureViewControllable.swift
//  StampFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency

public protocol StampFeatureViewControllable: ViewControllable { }

public protocol StampFeatureViewBuildable {
    func makeMissionListVC(sceneType: MissionListSceneType) -> StampFeatureViewControllable
    func makeListDetailVC(sceneType: ListDetailSceneType,
                          starLevel: StarViewLevel,
                          missionId: Int,
                          missionTitle: String,
                          otherUserId: Int?) -> StampFeatureViewControllable
    func makeMissionCompletedVC(starLevel: StarViewLevel, completionHandler: (() -> Void)?) -> StampFeatureViewControllable
    func makeRankingVC() -> StampFeatureViewControllable
    func makeAlertVC(type: AlertType,
                     title: String,
                     description: String,
                     customButtonTitle: String,
                     customAction: (() -> Void)?) -> StampFeatureViewControllable
    func makeNetworkAlertVC() -> StampFeatureViewControllable
}
