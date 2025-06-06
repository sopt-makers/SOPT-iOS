
//
//  DailySoptuneCardCoordinator.swift
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

public final class DailySoptuneCardCoordinator: DefaultCoordinator {
    
    public var requestCoordinating: (() -> Void)?
    public var finishFlow: (() -> Void)?
        
    private var navigationController: UINavigationController
    private let factory: DailySoptuneBuildable
    private let cardModel: DailySoptuneCardModel
    
    private weak var rootViewController: UIViewController?
    
    public init(
        navigationController: UINavigationController,
        factory: DailySoptuneBuildable,
        cardModel: DailySoptuneCardModel
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.cardModel = cardModel
    }
    
    public override func start() {
        showDailySoptuneCard()
    }
    
    private func showDailySoptuneCard() {
        var dailySoptuneCard = factory.makeDailySoptuneCardVC(cardModel: cardModel)
        
        dailySoptuneCard.vm.onBackButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigationController.dismiss(animated: true)
            self.finishFlow?()
        }
        
        dailySoptuneCard.vm.onGoToHomeButtonTapped = { [weak self] in
            self?.requestCoordinating?()
            self?.navigationController.dismiss(animated: true)
            self?.finishFlow?()
        }
        
        rootViewController = dailySoptuneCard.vc
        rootViewController?.modalPresentationStyle = .overFullScreen
        navigationController.present(dailySoptuneCard.vc, animated: true)
    }
}
