//
//  DailySoptuneResultCoordinator.swift
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
import WebFeature


public final class DailySoptuneResultCoordinator: DefaultDailySoptuneCoordinator {
    
    public var requestCoordinating: (() -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: DailySoptuneBuildable
    private let pokeFactory: PokeFeatureBuildable
    private let resultModel: DailySoptuneResultModel
    
    private var navigationController: UINavigationController
    private weak var rootController: UINavigationController?

    public init(
        navigationController: UINavigationController,
        factory: DailySoptuneBuildable,
        pokeFactory: PokeFeatureBuildable,
        resultModel: DailySoptuneResultModel
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.pokeFactory = pokeFactory
        self.resultModel = resultModel
    }
    
    public override func start() {
        showDailySoptuneResult(resultModel: resultModel)
    }
    
    private func showDailySoptuneResult(resultModel: DailySoptuneResultModel) {
        var dailySoptuneResult = factory.makeDailySoptuneResultVC(resultModel: resultModel)
        
        dailySoptuneResult.vm.onNaviBackButtonTapped = { [weak self] in
            self?.navigationController.dismiss(animated: true)
            self?.finishFlow?()
        }
        
        dailySoptuneResult.vm.onKokButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: rootController)
        }
        
        dailySoptuneResult.vm.onReceiveTodaysFortuneCardButtonTapped = { [weak self] cardModel in
            guard let self else { return }
            self.runDailySoptuneCardFlow(cardModel: cardModel)
        }
        
        dailySoptuneResult.vm.onProfileImageTapped = { [weak self] playgroundId in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(playgroundId)") else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.navigationController.pushViewController(webView, animated: true)
        }
        
        let navController = UINavigationController(rootViewController: dailySoptuneResult.vc)
        navController.modalPresentationStyle = .overFullScreen
        rootController = navController
        navigationController.present(navController, animated: true)
    }
    
    internal func runDailySoptuneCardFlow(cardModel: DailySoptuneCardModel) {
        let dailySoptuneCardCoordinator = DailySoptuneCardCoordinator(
            navigationController: rootController ?? UIWindow.getRootNavigationController,
            factory: factory,
            cardModel: cardModel
        )
        
        dailySoptuneCardCoordinator.finishFlow = { [weak self, weak dailySoptuneCardCoordinator] in
            dailySoptuneCardCoordinator?.childCoordinators = []
            self?.removeDependency(dailySoptuneCardCoordinator)
        }
        
        dailySoptuneCardCoordinator.requestCoordinating = { [weak self] in
            self?.requestCoordinating?()
            self?.navigationController.dismiss(animated: true)
            self?.finishFlow?()
        }
        
        addDependency(dailySoptuneCardCoordinator)
        dailySoptuneCardCoordinator.start()
    }
    
    private func showMessageBottomSheet(userModel: PokeUserModel, on view: UIViewController?) -> AnyPublisher<(PokeUserModel, PokeMessageModel, isAnonymous: Bool), Never> {
        let messageType: PokeMessageType = userModel.isFirstMeet ? .pokeSomeone : .pokeFriend
        
        guard let bottomSheet = self.pokeFactory
            .makePokeMessageTemplateBottomSheet(messageType: messageType)
            .vc
            .viewController as? PokeMessageTemplatesViewControllable
        else { return .empty() }
        
        let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate(minHeight: bottomSheet.minimumContentHeight))
        
        bottomSheetManager.present(toPresent: bottomSheet.viewController, on: view)
        
        return bottomSheet
            .signalForClick()
            .map { (userModel, $0, $1)}
            .asDriver()
    }
}
