//
//  DailySoptuneResultCoordinator.swift
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
import WebFeature

public final class DailySoptuneResultCoordinator: DefaultCoordinator {
    
    public var requestCoordinating: (() -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: DailySoptuneFeatureBuildable
    private let pokeFactory: PokeFeatureBuildable
    private let resultModel: DailySoptuneResultModel
    private let router: LegacyRouter
    private weak var rootController: UINavigationController?
    private weak var viewController: UIViewController?

    public init(router: LegacyRouter, factory: DailySoptuneFeatureBuildable, pokeFactory: PokeFeatureBuildable, resultModel: DailySoptuneResultModel) {
        self.router = router
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
            self?.router.dismissModule(animated: true)
            self?.finishFlow?()
        }
        
        dailySoptuneResult.vm.onKokButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: self.viewController)
        }
        
        dailySoptuneResult.vm.onReceiveTodaysFortuneCardButtonTapped = { [weak self] cardModel in
            guard let self else { return }
            self.runDailySoptuneCardFlow(cardModel: cardModel)
        }
        
        dailySoptuneResult.vm.onProfileImageTapped = { [weak self] playgroundId in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(playgroundId)") else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.rootController?.pushViewController(webView, animated: true)
        }
        
        rootController = dailySoptuneResult.vc.asNavigationController
        viewController = dailySoptuneResult.vc.viewController
        router.present(rootController, animated: true, modalPresentationSytle: .overFullScreen)
    }
    
    internal func runDailySoptuneCardFlow(cardModel: DailySoptuneCardModel) {
        let dailySoptuneCardCoordinator = DailySoptuneCardCoordinator(
            router: LegacyRouter(
                rootController: rootController ?? self.router.asNavigationController
            ), factory: factory
            , cardModel: cardModel
        )
        
        dailySoptuneCardCoordinator.finishFlow = { [weak self, weak dailySoptuneCardCoordinator] in
            dailySoptuneCardCoordinator?.childCoordinators = []
            self?.removeDependency(dailySoptuneCardCoordinator)
        }
        
        dailySoptuneCardCoordinator.requestCoordinating = { [weak self] in
            self?.requestCoordinating?()
            self?.router.dismissModule(animated: true)
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
        
        self.router.showBottomSheet(manager: bottomSheetManager,
                                    toPresent: bottomSheet.viewController,
                                    on: view)
        
        return bottomSheet
            .signalForClick()
            .map { (userModel, $0, $1)}
            .asDriver()
    }
}
