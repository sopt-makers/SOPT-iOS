//
//  StampBuilder.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency
@_exported import StampFeatureInterface

public
final class StampBuilder {
    @Injected public var missionListRepository: MissionListRepositoryInterface
    @Injected public var rankingRepository: RankingRepositoryInterface
    @Injected public var listDetailRepository: ListDetailRepositoryInterface

    public init() { }
}

extension StampBuilder: StampFeatureBuildable {
    public func makeMissionListVC(sceneType: MissionListSceneType, coordinator: Coordinator) -> MissionListPresentable {
        let useCase = DefaultMissionListUseCase(repository: missionListRepository)
        let viewModel = MissionListViewModel(useCase: useCase, sceneType: sceneType, coordinator: coordinator)
        let missionListVC = MissionListVC(viewModel: viewModel)
        return (missionListVC, viewModel)
    }

    public func makeListDetailVC(
        sceneType: ListDetailSceneType,
        starLevel: StarViewLevel,
        missionId: Int,
        missionTitle: String,
        otherUserName: String?
    ) -> ListDetailPresentable {
        let useCase = DefaultListDetailUseCase(repository: listDetailRepository)
        let viewModel = ListDetailViewModel(
            useCase: useCase,
            sceneType: sceneType,
            starLevel: starLevel,
            missionId: missionId,
            missionTitle: missionTitle,
            otherUsername: otherUserName
        )
        let listDetailVC = ListDetailVC(viewModel: viewModel)
        return (listDetailVC, viewModel)
    }

    public func makeMissionCompletedVC(
        starLevel: StarViewLevel,
        completionHandler: (() -> Void)?
    ) -> UIViewController {
        let missionCompletedVC = MissionCompletedVC()
            .setLevel(starLevel)
        missionCompletedVC.completionHandler = completionHandler
        missionCompletedVC.modalPresentationStyle = .overFullScreen
        missionCompletedVC.modalTransitionStyle = .crossDissolve
        return missionCompletedVC
    }

    public func makeRankingVC(rankingViewType: RankingViewType) -> RankingPresentable {
        let useCase = DefaultRankingUseCase(repository: rankingRepository)
        let viewModel = RankingViewModel(
            rankingViewType: rankingViewType,
            useCase: useCase
        )
        let rankingVC = RankingVC(rankingViewType: rankingViewType)
        rankingVC.viewModel = viewModel
        return (rankingVC, viewModel)
    }

    public func makePartRankingVC(rankingViewType: RankingViewType) -> PartRankingPresentable {
        let useCase = DefaultRankingUseCase(repository: rankingRepository)
        let viewModel = PartRankingViewModel(rankingViewType: rankingViewType, useCase: useCase)
        let partRankingVC = PartRankingVC(rankingViewType: rankingViewType)
        partRankingVC.viewModel = viewModel
        return (partRankingVC, viewModel)
    }

    public func makeStampGuideVC() -> any StampGuideViewControllable {
        let stampGuideVC = StampGuideVC()
        return stampGuideVC
    }

    public func makeClapListVC() -> ClapListPresentable {
        let viewModel = ClapListViewModel()
        let clapListVC = ClapListVC(viewModel: viewModel)
        return (
            clapListVC as any ClapListViewControllable,
            viewModel as any ClapListViewModelType
        )
    }
}
