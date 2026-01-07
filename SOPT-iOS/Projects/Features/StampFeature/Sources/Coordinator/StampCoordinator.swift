//
//  StampCoordinator.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import BaseFeatureDependency
import StampFeatureInterface
import SafariServices
import AppMyPageFeatureInterface

public final class StampCoordinator: BaseCoordinator {

    // MARK: - Properties

    private let factory: StampFeatureBuildable
    private let mypageFactory: MyPageFeatureBuildable
    private let navigationController: UINavigationController
    private weak var rootController: UINavigationController?

    // MARK: - Init

    public init(
        navigationController: UINavigationController,
        factory: StampFeatureBuildable,
        mypageFactory: MyPageFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.mypageFactory = mypageFactory
    }

    // MARK: - Coordinator Life Cycle

    public func start(isRouteFromTabBar: Bool = false) {
        showMissionList(sceneType: .default, isRouteFromTabBar: isRouteFromTabBar)
    }

    public override func start() {
        start(isRouteFromTabBar: false)
    }

    // MARK: - Navigation

    private func showMissionList(sceneType: MissionListSceneType, isRouteFromTabBar: Bool) {
        var missionList = factory.makeMissionListVC(sceneType: sceneType, isRouteFromTabBar: isRouteFromTabBar, coordinator: self)

        if isRouteFromTabBar {
            self.rootController = self.navigationController
            self.navigationController.setViewControllers([missionList.vc], animated: false)
        } else {
            let navController = UINavigationController(rootViewController: missionList.vc)
            navController.modalPresentationStyle = .overFullScreen
            self.rootController = navController

            missionList.vc.onNaviBackTap = { [weak self] in
                guard let self else { return }
                self.navigationController.dismiss(animated: true)
            }

            self.navigationController.present(navController, animated: true)
        }

        missionList.vc.onEditTap = { [weak self] in
            guard let self else { return }
            let vc = self.mypageFactory.makeSentenceEditVC()
            self.rootController?.pushViewController(vc, animated: true)
        }
        missionList.vc.onPartRankingButtonTap = { [weak self] rankingViewType in
            guard let self else { return }
            self.runRankingFlow(rankingViewType: rankingViewType)
        }

        missionList.vc.onCurrentGenerationRankingButtonTap = { [weak self] rankingViewType in
            guard let self else { return }
            self.runRankingFlow(rankingViewType: rankingViewType)
        }

        missionList.vc.onCellTap = { [weak self] model, username in
            guard let self else { return }
            self.showMissionDetail(model, username)
        }

        missionList.vc.onReportButtonTap = { [weak self] in
            guard let self else { return }
            guard let url = UserDefaultKeyList.Soptamp.reportUrl else { return }
            let safariViewController = SFSafariViewController(url: URL(string: url)!)
            safariViewController.playgroundStyle()
            self.rootController?.present(safariViewController, animated: true)
        }

        missionList.vc.onAppJamRankingButtonTap = { [weak self] in
            guard let self else { return }
            self.runRankingFlow(rankingViewType: .appJamRanking)
        }
    }
}

// MARK: - MissionDetailFlow

extension StampCoordinator {
    public func runOtherMissionList(username: String, sentence: String) {
        showOtherMissionList(username, sentence)
    }

    public func runMissionDetailById(missionId: Int, level: Int, missionTitle: String, username: String?) {
        let model = MissionListModel(
            id: missionId,
            title: missionTitle,
            level: level,
            isCompleted: true
        )
        showMissionDetail(model, username)
    }

    private func showMissionDetail(_ model: MissionListModel, _ username: String?) {
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
            self.rootController?.popViewController(animated: true)
        }

        missionDetail.vc.onViewClapTap = { [weak self] stampId, nickname in
            guard let self else { return }
            self.showClapList(stampId: stampId, nickname: nickname)
        }

        rootController?.pushViewController(missionDetail.vc, animated: true)
    }

    private func showMissionComplete(_ level: StarViewLevel, _ handler: (() -> Void)?) {
        let missionCompleted = factory.makeMissionCompletedVC(
            starLevel: level,
            completionHandler: handler
        )

        rootController?.present(missionCompleted, animated: true)
    }
}

// MARK: - RankingFlow

extension StampCoordinator {
    public func runRankingFlow(rankingViewType: RankingViewType) {
        switch rankingViewType {
        case .all, .currentGeneration, .individualRankingInPart:
            showRanking(rankingViewType: rankingViewType)
        case .partRanking:
            showPartRanking(rankingViewType)
        case .appJamRanking:
            showAppJamRanking()
        }
    }

    private func showRanking(rankingViewType: RankingViewType) {
        var ranking = factory.makeRankingVC(rankingViewType: rankingViewType)

        ranking.vc.onCellTap = { [weak self] (username, sentence) in
            guard let self else { return }
            self.showOtherMissionList(username, sentence)
        }

        ranking.vc.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.rootController?.popViewController(animated: true)
        }

        rootController?.pushViewController(ranking.vc, animated: true)
    }

    private func showPartRanking(_ rankingViewType: RankingViewType) {
        var ranking = factory.makePartRankingVC(rankingViewType: rankingViewType)

        ranking.vc.onCellTap = { [weak self] part in
            guard let self else { return }
            self.showRanking(rankingViewType: .individualRankingInPart(part: part))
        }

        ranking.vc.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.rootController?.popViewController(animated: true)
        }

        rootController?.pushViewController(ranking.vc, animated: true)
    }
    
    private func showAppJamRanking() {
        var ranking = factory.makeAppJamRankingVC()
        
        ranking.vm.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.rootController?.popViewController(animated: true)
        }
        
        ranking.vm.onNetworkError = { [weak self] in
            guard let self else { return }
            AlertUtils.presentNetworkAlertVC()
        }
        
        rootController?.pushViewController(ranking.vc, animated: true)
    }

    private func showOtherMissionList(_ username: String, _ sentence: String) {
        var otherMissionList = factory.makeMissionListVC(
            sceneType: .ranking(userName: username, sentence: sentence),
            isRouteFromTabBar: false,
            coordinator: self
        )

        otherMissionList.vc.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.rootController?.popViewController(animated: true)
        }

        otherMissionList.vc.onSwiped = { [weak self] in
            guard let self else { return }
            self.rootController?.popViewController(animated: true)
        }

        otherMissionList.vc.onCellTap = { [weak self] model, username in
            guard let self else { return }
            self.showMissionDetail(model, username)
        }

        rootController?.pushViewController(otherMissionList.vc, animated: true)
    }
}

// MARK: - ClapListFlow

extension StampCoordinator {
    public func showClapList(stampId: Int, nickname: String) {
        var clapList = factory.makeClapListVC(
            stampId: stampId,
            nickname: nickname
        )

        clapList.vc.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.rootController?.dismiss(animated: true)
        }

        clapList.vc.onCellTap = { [weak self] username in
            guard let self else { return }
            guard let username else { return }

            self.rootController?.dismiss(animated: true) {
                self.showOtherMissionList(username, "")
            }
        }

        clapList.vc.modalPresentationStyle = .overFullScreen
        self.rootController?.topViewController?.present(clapList.vc, animated: true)
    }
}
