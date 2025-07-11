//
//  LegacyRankingCoordinator.swift
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
final class LegacyRankingCoordinator: DefaultCoordinator {
        
    public var finishFlow: (() -> Void)?
    
    private let factory: LegacyStampFeatureViewBuildable
    private let router: LegacyRouter
    private let rankingViewType: RankingViewType
    
    public init(
        router: LegacyRouter,
        factory: LegacyStampFeatureViewBuildable,
        rankingViewType: RankingViewType
    ) {
        self.factory = factory
        self.router = router
        self.rankingViewType = rankingViewType
    }
    
    public override func start() {
      switch rankingViewType {
      case .all, .currentGeneration, .individualRankingInPart:
        showRanking(rankingViewType: rankingViewType)
      case .partRanking:
        showPartRanking()
      }
    }
    
    private func showRanking(rankingViewType: RankingViewType) {
        var ranking = factory.makeRankingVC(rankingViewType: rankingViewType)

        ranking.onCellTap = { [weak self] (username, sentence) in
            self?.showOtherMissionList(username, sentence)
        }
        ranking.onNaviBackTap = { [weak self] in
            self?.router.popModule()
        }
        router.push(ranking)
    }

    private func showPartRanking() {
      var ranking = factory.makePartRankingVC(rankingViewType: self.rankingViewType)

      ranking.onCellTap = { [weak self] part in
        self?.showRanking(rankingViewType: .individualRankingInPart(part: part))
      }
      ranking.onNaviBackTap = { [weak self] in
          self?.router.popModule()
          self?.finishFlow?()
      }
      router.push(ranking)
    }

    private func showOtherMissionList(_ username: String, _ sentence: String) {
        var otherMissionList = factory.makeMissionListVC(
            sceneType: .ranking(userName: username, sentence: sentence),
            coordinator: self
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
        let missionDetailCoordinator = LegacyMissionDetailCoordinator(
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
