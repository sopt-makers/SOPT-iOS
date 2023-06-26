//
//  MissionDetailCoordinator.swift
//  StampFeature
//
//  Created by Junho Lee on 2023/06/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency
import StampFeatureInterface

public
final class MissionDetailCoordinator: DefaultCoordinator {
        
    public var finishFlow: (() -> Void)?
    
    private let factory: StampFeatureViewBuildable
    private let router: Router
    private let model: MissionListModel
    private let username: String?
    
    public init(router: Router, factory: StampFeatureViewBuildable, model: MissionListModel, username: String?) {
        self.factory = factory
        self.router = router
        self.model = model
        self.username = username
    }
    
    public override func start() {
        showMissionDetail()
    }
    
    private func showMissionDetail() {
        guard let starLevel = StarViewLevel.init(rawValue: model.level) else { return }
        var missionDetail = factory.makeListDetailVC(
            sceneType: model.toListDetailSceneType(),
            starLevel: starLevel,
            missionId: model.id,
            missionTitle: model.title,
            otherUserName: username
        )
        missionDetail.onComplete = { [weak self] starViewLevel, handler in
            self?.showMissionComplete(starViewLevel, handler)
        }
        router.push(missionDetail)
    }
    
    private func showMissionComplete(_ level: StarViewLevel, _ handler: (() -> Void)?) {
        let missionCompleted = factory.makeMissionCompletedVC(
            starLevel: level,
            completionHandler: handler
        )
        router.present(missionCompleted, animated: true)
    }
}
