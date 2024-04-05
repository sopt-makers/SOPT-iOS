//
//  StampBuilder.swift
//  StampFeature
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import StampFeatureInterface

public
final class StampBuilder {
    @Injected public var missionListRepository: MissionListRepositoryInterface
    @Injected public var rankingRepository: RankingRepositoryInterface
    @Injected public var listDetailRepository: ListDetailRepositoryInterface
    
    public init() { }
}

extension StampBuilder: StampFeatureViewBuildable {
    public func makeMissionListVC(sceneType: MissionListSceneType) -> MissionListViewControllable {
        let useCase = DefaultMissionListUseCase(repository: missionListRepository)
        let viewModel = MissionListViewModel(useCase: useCase, sceneType: sceneType)
        let missionListVC = MissionListVC()
        missionListVC.viewModel = viewModel
        return missionListVC
    }
    
    public func makeListDetailVC(
        sceneType: ListDetailSceneType,
        starLevel: StarViewLevel,
        missionId: Int,
        missionTitle: String,
        otherUserName: String?
    ) -> ListDetailViewControllable {
        let useCase = DefaultListDetailUseCase(repository: listDetailRepository)
        let viewModel = ListDetailViewModel(
            useCase: useCase,
            sceneType: sceneType,
            starLevel: starLevel,
            missionId: missionId,
            missionTitle: missionTitle,
            otherUsername: otherUserName
        )
        let listDetailVC = ListDetailVC()
        listDetailVC.viewModel = viewModel
        return listDetailVC
    }
    
    public func makeMissionCompletedVC(
        starLevel: StarViewLevel,
        completionHandler: (() -> Void)?
    ) -> MissionCompletedViewControllable {
        let missionCompletedVC = MissionCompletedVC()
            .setLevel(starLevel)
        missionCompletedVC.completionHandler = completionHandler
        missionCompletedVC.modalPresentationStyle = .overFullScreen
        missionCompletedVC.modalTransitionStyle = .crossDissolve
        return missionCompletedVC
    }
    
    public func makeRankingVC(rankingViewType: RankingViewType) -> RankingViewControllable {
        let useCase = DefaultRankingUseCase(repository: rankingRepository)
        let viewModel = RankingViewModel(
            rankingViewType: rankingViewType,
            useCase: useCase
        )
        let rankingVC = RankingVC(rankingViewType: rankingViewType)
        rankingVC.viewModel = viewModel
        return rankingVC
    }
    
    public func makeStampGuideVC() -> StampGuideViewControllable {
        let stampGuideVC = StampGuideVC()
        return stampGuideVC
    }

    public func makePartRankingVC(rankingViewType: RankingViewType) -> PartRankingViewControllable {
      let vc = PartRankingVC(rankingViewType: rankingViewType)
      let useCase = DefaultRankingUseCase(repository: rankingRepository)
      vc.viewModel = PartRankingViewModel(rankingViewType: rankingViewType, useCase: useCase)
      return vc
    }
}
