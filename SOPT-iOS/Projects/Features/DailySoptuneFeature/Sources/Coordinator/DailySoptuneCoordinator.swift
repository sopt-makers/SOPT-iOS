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
    public var finishFlow: (() -> Void)?
    
    private let factory: DailySoptuneFeatureBuildable
    private let pokeFactory: PokeFeatureBuildable
    private let router: Router
    
    public init(router: Router, factory: DailySoptuneFeatureBuildable, pokeFactory: PokeFeatureBuildable) {
        self.router = router
        self.factory = factory
        self.pokeFactory = pokeFactory
    }
    
    public override func start() {
        showDailySoptuneResult()
    }
    
    private func showDailySoptuneResult() {
        var dailySoptuneResult = factory.makeDailySoptuneResultVC()
        
        dailySoptuneResult.vm.onNaviBackButtonTap = { [weak self] in
            self?.router.dismissModule(animated: true)
            self?.finishFlow?()
        }
        
        dailySoptuneResult.vm.onKokButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: dailySoptuneResult.vc.viewController)
        }
        
        dailySoptuneResult.vm.onReceiveTodaysFortuneCardButtonTapped = { [weak self] cardModel in
            guard let self else { return }
            let dailySoptuneCardVC = self.factory.makeDailySoptuneCardVC(cardModel: cardModel).viewController
            dailySoptuneCardVC.modalPresentationStyle = .overFullScreen
            dailySoptuneResult.vc.viewController.present(dailySoptuneCardVC, animated: false)
        }
        
        router.push(dailySoptuneResult.vc)
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
