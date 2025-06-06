//
//  DailySoptuneCoordinator.swift
//  DailySoptuneFeature
//
//  Created by 강윤서 on 6/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import BaseFeatureDependency
import DailySoptuneFeatureInterface
import Domain
import PokeFeatureInterface

public final class DailySoptuneCoordinator: DefaultDailySoptuneCoordinator {
    
    public var requestCoordinating: (() -> Void)?
    public var finishFlow: (() -> Void)?
    
    private var navigationController: UINavigationController
    private let factory: DailySoptuneBuildable
    private let pokeFactory: PokeFeatureBuildable
    
    private weak var rootController: UINavigationController?
    
    public init(navigationController: UINavigationController,
                factory: DailySoptuneBuildable,
                pokeFactory: PokeFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.pokeFactory = pokeFactory
    }
    
    public override func start() {
        showDailySoptuneMain()
    }
    
    private func showDailySoptuneMain() {
        var dailySoptuneMain = factory.makeDailySoptuneMainVC()
        
        dailySoptuneMain.vm.onNaviBackTap = { [weak self] in
            self?.navigationController.dismiss(animated: true)
            self?.finishFlow?()
        }
        
        dailySoptuneMain.vm.onReciveTodayFortuneButtonTap = { [weak self] result in
            guard let self else { return }
            runDailySoptuneResultFlow(resultModel: result)
        }
        
        let navController = UINavigationController(rootViewController: dailySoptuneMain.vc)
        navController.modalPresentationStyle = .overFullScreen
        rootController = navController
        navigationController.present(navController, animated: true)
    }
    
    internal func runDailySoptuneResultFlow(resultModel: DailySoptuneResultModel) {
        let dailySoptuneResultCoordinator = DailySoptuneResultCoordinator(
            navigationController: rootController ?? UIWindow.getRootNavigationController,
            factory: factory,
            pokeFactory: pokeFactory,
            resultModel: resultModel
        )
        
        dailySoptuneResultCoordinator.finishFlow = { [weak self, weak dailySoptuneResultCoordinator] in
            dailySoptuneResultCoordinator?.childCoordinators = []
            self?.removeDependency(dailySoptuneResultCoordinator)
        }
        
        dailySoptuneResultCoordinator.requestCoordinating = { [weak self] in
            self?.requestCoordinating?()
            self?.navigationController.dismiss(animated: true)
            self?.finishFlow?()
        }
        
        addDependency(dailySoptuneResultCoordinator)
        dailySoptuneResultCoordinator.start()
    }
}
