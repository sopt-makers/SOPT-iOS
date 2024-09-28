//
//  DailySoptuneCardCoordinator.swift
//  DailySoptuneFeature
//
//  Created by Jae Hyun Lee on 9/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import BaseFeatureDependency
import DailySoptuneFeatureInterface
import Domain

public final class DailySoptuneCardCoordinator: DefaultCoordinator {
    
    public var finishFlow: (() -> Void)?
        
    private let factory: DailySoptuneFeatureBuildable
    private let router: Router
    
    private let cardModel: DailySoptuneCardModel

    private weak var rootController: UINavigationController?
    
    public init(router: Router, factory: DailySoptuneFeatureBuildable, cardModel: DailySoptuneCardModel) {
        self.router = router
        self.factory = factory
        self.cardModel = cardModel
    }
    
    public override func start() {
        showDailySoptuneCard()
    }
    
    private func showDailySoptuneCard() {
        var dailySoptuneCard = factory.makeDailySoptuneCardVC(cardModel: cardModel)
        
        dailySoptuneCard.vm.onBackButtonTapped = { [weak self] in
            self?.router.dismissModule(animated: true)
            self?.finishFlow?()
        }
        
        self.rootController = dailySoptuneCard.vc.asNavigationController
        self.router.present(self.rootController, animated: true, modalPresentationSytle: .overFullScreen)
    }
}
