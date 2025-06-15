//
//  LegacyDailySoptuneCoordinator.swift
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

public final class LegacyDailySoptuneCoordinator: DefaultDailySoptuneCoordinator & DailySoptuneMainCoordinatable {
    
    public var onNaviBackTap: (() -> Void)?
    public var onReciveTodayFortuneButtonTap: ((Domain.DailySoptuneResultModel) -> Void)?
    
    public var requestCoordinating: (() -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: LegacyDailySoptuneFeatureBuildable
    private let pokeFactory: LegacyPokeFeatureBuildable
    private let router: LegacyRouter
    
    private weak var rootController: UINavigationController?
    
    public init(router: LegacyRouter, factory: LegacyDailySoptuneFeatureBuildable, pokeFactory: LegacyPokeFeatureBuildable) {
        self.router = router
        self.factory = factory
        self.pokeFactory = pokeFactory
    }
    
    public override func start() {
        showDailySoptuneMain()
    }
    
    private func showDailySoptuneMain() {
        var dailySoptuneMain = factory.makeDailySoptuneMainVC(coordinator: self)
        
        onNaviBackTap = { [weak self] in
            self?.router.dismissModule(animated: true)
            self?.finishFlow?()
        }
        
        onReciveTodayFortuneButtonTap = { [weak self] result in
            guard let self else { return }
            runDailySoptuneResultFlow(resultModel: result)
        }
        
        self.rootController = dailySoptuneMain.vc.asNavigationController
        self.router.present(self.rootController, animated: true, modalPresentationSytle: .overFullScreen)
    }
    
    internal func runDailySoptuneResultFlow(resultModel: DailySoptuneResultModel) {
        let dailySoptuneResultCoordinator = LegacyDailySoptuneResultCoordinator(router: LegacyRouter(
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
            self?.router.dismissModule(animated: true)
            self?.finishFlow?()
        }
        
        addDependency(dailySoptuneResultCoordinator)
        dailySoptuneResultCoordinator.start()
    }
}
