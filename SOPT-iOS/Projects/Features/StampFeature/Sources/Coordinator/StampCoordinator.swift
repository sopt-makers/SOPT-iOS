//
//  StampCoordinator.swift
//  StampFeature
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import StampFeatureInterface
import Domain

public
final class StampCoordinator: DefaultCoordinator {
        
    public var finishFlow: (() -> Void)?
    
    private let factory: StampFeatureViewBuildable
    private let router: Router
    // Note: @준호 - Soptamp는 Present되기 때문에 최상위 NavController의 참조를 유지해야 함
    private weak var rootController: UINavigationController?
    
    public init(router: Router, factory: StampFeatureViewBuildable) {
        self.factory = factory
        self.router = router
    }
    
    public override func start() {
        showMissionList(sceneType: .default)
    }
    
    private func showMissionList(sceneType: MissionListSceneType) {
        var missionList = factory.makeMissionListVC(sceneType: sceneType)
        missionList.onNaviBackTap = { [weak self] in
            self?.router.dismissModule(animated: true)
            self?.finishFlow?()
        }
        missionList.onGuideTap = { [weak self] in
            self?.showGuide()
        }
        missionList.onRankingButtonTap = { [weak self] rankingViewType in
            self?.runRankingFlow(rankingViewType: rankingViewType)
        }
        missionList.onCurrentGenerationRankingButtonTap = { [weak self] rankingViewType in
            self?.runRankingFlow(rankingViewType: rankingViewType)
        }
        missionList.onCellTap = { [weak self] model, username in
            self?.runMissionDetailFlow(model, username)
        }
        rootController = missionList.asNavigationController
        router.present(rootController, animated: true, modalPresentationSytle: .overFullScreen)
    }
    
    private func showGuide() {
        let guideCoordinator = StampGuideCoordinator(
            router: Router(rootController: rootController!),
            factory: factory
        )
        guideCoordinator.start()
    }
    
    private func runRankingFlow(rankingViewType: RankingViewType) {
        let rankingCoordinator = RankingCoordinator(
            router: Router(rootController: rootController!),
            factory: factory,
            rankingViewType: rankingViewType
        )
        rankingCoordinator.finishFlow = { [weak self, weak rankingCoordinator] in
            self?.removeDependency(rankingCoordinator)
        }
        addDependency(rankingCoordinator)
        rankingCoordinator.start()
    }
    
    private func runMissionDetailFlow(_ model: MissionListModel, _ username: String?) {
        let missionDetailCoordinator = MissionDetailCoordinator(
            router: Router(rootController: rootController!),
            factory: factory,
            model: model,
            username: username
        )
        missionDetailCoordinator.finishFlow = { [weak self, weak missionDetailCoordinator] in
            self?.removeDependency(missionDetailCoordinator)
        }
        addDependency(missionDetailCoordinator)
        missionDetailCoordinator.start()
    }
}

