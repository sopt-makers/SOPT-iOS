//
//  DailySoptuneCoordinator.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import BaseFeatureDependency
import DailySoptuneFeatureInterface
import Domain
import PokeFeatureInterface

public final class DailySoptuneCoordinator: DefaultCoordinator {
    
    public var requestCoordinating: (() -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: DailySoptuneFeatureBuildable
    private let pokeFactory: PokeFeatureBuildable
    private let router: Router
    
    private weak var rootController: UINavigationController?
    
    public init(router: Router, factory: DailySoptuneFeatureBuildable, pokeFactory: PokeFeatureBuildable) {
        self.router = router
        self.factory = factory
        self.pokeFactory = pokeFactory
    }
    
    public override func start() {
        showDailySoptuneMain()
    }
    
    private func showDailySoptuneMain() {
        var dailySoptuneMain = factory.makeDailySoptuneMainVC()
        
        dailySoptuneMain.vm.onNaviBackTap = {
            self.router.dismissModule(animated: true)
            self.finishFlow?()
        }
        
        dailySoptuneMain.vm.onReciveTodayFortuneButtonTap = { [weak self] result in
            guard let self else { return }
            runDailySoptuneResultFlow(resultModel: result)
        }
        
        self.rootController = dailySoptuneMain.vc.asNavigationController
        self.router.present(self.rootController, animated: true, modalPresentationSytle: .overFullScreen)
    }
    
    internal func runDailySoptuneResultFlow(resultModel: DailySoptuneResultModel) {
        let dailySoptuneResultCoordinator = DailySoptuneResultCoordinator(router: Router(
            rootController: rootController ?? self.router.asNavigationController
        ),
                                                                          factory: factory,
                                                                          pokeFactory: pokeFactory,
                                                                          resultModel: resultModel)
        
        dailySoptuneResultCoordinator.finishFlow = { [weak self, weak dailySoptuneResultCoordinator] in
            dailySoptuneResultCoordinator?.childCoordinators = []
            self?.removeDependency(dailySoptuneResultCoordinator)
        }
        
        dailySoptuneResultCoordinator.requestCoordinating = { [weak self] in
            self?.requestCoordinating?()
        }
        
        addDependency(dailySoptuneResultCoordinator)
        dailySoptuneResultCoordinator.start()
    }
}
