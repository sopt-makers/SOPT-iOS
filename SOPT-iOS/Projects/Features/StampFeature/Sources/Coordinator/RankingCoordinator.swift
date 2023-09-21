//
//  RankingCoordinator.swift
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
final class RankingCoordinator: DefaultCoordinator {
        
    public var finishFlow: (() -> Void)?
    
    private let factory: StampFeatureViewBuildable
    private let router: Router
    private let rankingViewType: RankingViewType
    
    public init(
        router: Router,
        factory: StampFeatureViewBuildable,
        rankingViewType: RankingViewType
    ) {
        self.factory = factory
        self.router = router
        self.rankingViewType = rankingViewType
    }
    
    public override func start() {
        showRanking()
    }
    
    private func showRanking() {
        var ranking = factory.makeRankingVC(rankingViewType: self.rankingViewType)
        ranking.onSwiped = { [weak self] in
            self?.router.popModule()
        }
        ranking.onCellTap = { [weak self] (username, sentence) in
            self?.showOtherMissionList(username, sentence)
        }
        ranking.onNaviBackTap = { [weak self] in
            self?.router.popModule()
            self?.finishFlow?()
        }
        router.push(ranking)
    }
    
    private func showOtherMissionList(_ username: String, _ sentence: String) {
        var otherMissionList = factory.makeMissionListVC(
            sceneType: .ranking(userName: username, sentence: sentence)
        )
        otherMissionList.onNaviBackTap = { [weak self] in
            self?.router.popModule()
        }
        otherMissionList.onSwiped = { [weak self] in
            self?.router.popModule()
        }
        otherMissionList.onCellTap = { [weak self] model, username in
            self?.runMissionDetailFlow(model, username)
        }
        router.push(otherMissionList)
    }
    
    private func runMissionDetailFlow(_ model: MissionListModel, _ username: String?) {
        let missionDetailCoordinator = MissionDetailCoordinator(
            router: router,
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
