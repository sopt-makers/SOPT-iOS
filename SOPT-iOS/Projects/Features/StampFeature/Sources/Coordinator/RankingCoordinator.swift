//
//  RankingCoordinator.swift
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

public final class RankingCoordinator: DefaultCoordinator {
    
    // MARK: - Properties
    
    public var finishFlow: (() -> Void)?
    
    private let factory: StampFeatureBuildable
    private let navigationController: UINavigationController
    private let rankingViewType: RankingViewType
        
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: StampFeatureBuildable,
        rankingViewType: RankingViewType
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.rankingViewType = rankingViewType
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        switch rankingViewType {
        case .all, .currentGeneration, .individualRankingInPart:
            showRanking(rankingViewType: rankingViewType)
        case .partRanking:
            showPartRanking()
        }
    }
    
    // MARK: - Navigation
    
    private func showRanking(rankingViewType: RankingViewType) {
        var ranking = factory.makeRankingVC(rankingViewType: rankingViewType)
        
        ranking.vc.onCellTap = { [weak self] (username, sentence) in
            guard let self else { return }
            self.showOtherMissionList(username, sentence)
        }
        
        ranking.vc.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.navigationController.popViewController(animated: true)
        }

        navigationController.pushViewController(ranking.vc, animated: true)
    }
    
    private func showPartRanking() {
        var ranking = factory.makePartRankingVC(rankingViewType: self.rankingViewType)
        
        ranking.vc.onCellTap = { [weak self] part in
            guard let self else { return }
            self.showRanking(rankingViewType: .individualRankingInPart(part: part))
        }
        
        ranking.vc.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.navigationController.popViewController(animated: true)
            self.finishFlow?()
        }

        navigationController.pushViewController(ranking.vc, animated: true)
    }
    
    private func showOtherMissionList(_ username: String, _ sentence: String) {
        var otherMissionList = factory.makeMissionListVC(
            sceneType: .ranking(userName: username, sentence: sentence)
        )
        
        otherMissionList.vc.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.navigationController.popViewController(animated: true)
        }
        
        otherMissionList.vc.onSwiped = { [weak self] in
            guard let self else { return }
            self.navigationController.popViewController(animated: true)
        }
        
        otherMissionList.vc.onCellTap = { [weak self] model, username in
            guard let self else { return }
            self.runMissionDetailFlow(model, username)
        }
        
        navigationController.pushViewController(otherMissionList.vc, animated: true)
    }
    
    private func runMissionDetailFlow(_ model: MissionListModel, _ username: String?) {
        let missionDetailCoordinator = MissionDetailCoordinator(
            navigationController: navigationController,
            factory: factory,
            model: model,
            username: username
        )
        
        missionDetailCoordinator.finishFlow = { [weak self, weak missionDetailCoordinator] in
            guard let self else { return }
            self.removeDependency(missionDetailCoordinator)
        }
        
        addDependency(missionDetailCoordinator)
        missionDetailCoordinator.start()
    }
}
