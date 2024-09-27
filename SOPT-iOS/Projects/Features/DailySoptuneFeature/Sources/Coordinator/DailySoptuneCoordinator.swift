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
import PokeFeature
import PokeFeatureInterface

public final class DailySoptuneCoordinator: DefaultCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let factory: DailySoptuneFeatureBuildable
    private let router: Router
    
    public init(router: Router, factory: DailySoptuneFeatureBuildable) {
        self.router = router
        self.factory = factory
    }
    
    public override func start() {
        showDailySoptuneResult()
    }
    
    private func showDailySoptuneResult() {
        var dailySoptuneResult = factory.makeDailySoptuneResultVC()
        
        dailySoptuneResult.vm.onKokButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: dailySoptuneResult.vc.viewController)
        }
        
        router.push(dailySoptuneResult.vc)
    }
    
    private func showMessageBottomSheet(userModel: PokeUserModel, on view: UIViewController?) -> AnyPublisher<(PokeUserModel, PokeMessageModel, isAnonymous: Bool), Never> {
        let messageType: PokeMessageType = userModel.isFirstMeet ? .pokeSomeone : .pokeFriend
        
        guard let bottomSheet = self.factory
            .makePokeMessageTemplateBottomSheet(messageType: messageType)
            .vc
            .viewController as? PokeMessageTemplateBottomSheet
        else { return .empty() }
        
        let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate(minHeight: PokeMessageTemplateBottomSheet.minimunContentHeight))
        
        self.router.showBottomSheet(manager: bottomSheetManager,
                                    toPresent: bottomSheet,
                                    on: view)
        
        return bottomSheet
            .signalForClick()
            .map { (userModel, $0, $1)}
            .asDriver()
    }
}
