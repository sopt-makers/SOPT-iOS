//
//  MissionDetailCoordinator.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency
import StampFeatureInterface

public final class MissionDetailCoordinator: DefaultCoordinator {
    
    // MARK: - Properties
    
    public var finishFlow: (() -> Void)?
    
    private let factory: StampFeatureBuildable
    private let navigationController: UINavigationController
    private let model: MissionListModel
    private let username: String?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: StampFeatureBuildable,
        model: MissionListModel,
        username: String?
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.model = model
        self.username = username
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showMissionDetail()
    }
    
    // MARK: - Navigation
    
    private func showMissionDetail() {
        guard let starLevel = StarViewLevel.init(rawValue: model.level) else { return }
        
        var missionDetail = factory.makeListDetailVC(
            sceneType: model.toListDetailSceneType(),
            starLevel: starLevel,
            missionId: model.id,
            missionTitle: model.title,
            otherUserName: username
        )
        
        missionDetail.vc.onComplete = { [weak self] starViewLevel, handler in
            guard let self else { return }
            self.showMissionComplete(starViewLevel, handler)
        }
        
        missionDetail.vc.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.navigationController.popViewController(animated: true)
            self.finishFlow?()
        }
        
        navigationController.pushViewController(missionDetail.vc, animated: true)
    }
    
    private func showMissionComplete(_ level: StarViewLevel, _ handler: (() -> Void)?) {
        let missionCompleted = factory.makeMissionCompletedVC(
            starLevel: level,
            completionHandler: handler
        )
        
        navigationController.present(missionCompleted, animated: true)
    }
}
