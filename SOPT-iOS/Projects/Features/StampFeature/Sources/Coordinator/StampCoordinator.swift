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

public final class StampCoordinator: DefaultCoordinator {
        
    // MARK: - Properties
    
    public var finishFlow: (() -> Void)?
    
    private let factory: StampFeatureBuildable
    private let navigationController: UINavigationController
    
    private weak var rootController: UINavigationController?
        
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: StampFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showMissionList(sceneType: .default)
    }
    
    // MARK: - Navigation
    
    private func showMissionList(sceneType: MissionListSceneType) {
        var missionList = factory.makeMissionListVC(sceneType: sceneType)
        
        missionList.vc.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.navigationController.dismiss(animated: true)
            self.finishFlow?()
        }
        
        missionList.vc.onGuideTap = { [weak self] in
            guard let self else { return }
            self.showGuide()
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
            self.runMissionDetailFlow(model, username)
        }
        
        missionList.vc.onReportButtonTap = { [weak self] in
            guard let self else { return }
            guard let url = UserDefaultKeyList.Soptamp.reportUrl else { return }
            let safariViewController = SFSafariViewController(url: URL(string: url)!)
            safariViewController.playgroundStyle()
            self.rootController?.present(safariViewController, animated: true)
        }
        
        let navController = UINavigationController(rootViewController: missionList.vc)
        navController.modalPresentationStyle = .overFullScreen
        rootController = navController
        navigationController.present(navController, animated: true)
    }
    
    private func showGuide() {
        let guideCoordinator = StampGuideCoordinator(
            navigationController: rootController ?? UIWindow.getRootNavigationController,
            factory: factory
        )
        
        guideCoordinator.finishFlow = { [weak self, weak guideCoordinator] in
            guard let self else { return }
            self.removeDependency(guideCoordinator)
        }
        
        addDependency(guideCoordinator)
        guideCoordinator.start()
    }
    
    internal func runRankingFlow(rankingViewType: RankingViewType) {
        let rankingCoordinator = RankingCoordinator(
            navigationController: rootController ?? UIWindow.getRootNavigationController,
            factory: factory,
            rankingViewType: rankingViewType
        )
        
        rankingCoordinator.finishFlow = { [weak self, weak rankingCoordinator] in
            guard let self else { return }
            self.removeDependency(rankingCoordinator)
        }
        
        addDependency(rankingCoordinator)
        rankingCoordinator.start()
    }
    
    private func runMissionDetailFlow(_ model: MissionListModel, _ username: String?) {
        let missionDetailCoordinator = MissionDetailCoordinator(
            navigationController: rootController ?? UIWindow.getRootNavigationController,
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
