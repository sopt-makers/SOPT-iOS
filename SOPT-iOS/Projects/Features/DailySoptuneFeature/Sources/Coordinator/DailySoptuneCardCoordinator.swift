
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
        
    private var rootViewController: UIViewController
    private let factory: DailySoptuneBuildable
    private let cardModel: DailySoptuneCardModel
    
    public init(
        navigationController: UIViewController,
        factory: DailySoptuneBuildable,
        cardModel: DailySoptuneCardModel
    ) {
        self.rootViewController = navigationController
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
            self.rootViewController.dismiss(animated: true)
            self.finishFlow?()
        }
        
        dailySoptuneCard.vm.onGoToHomeButtonTapped = { [weak self] in
//            self?.delegate?.requestAllDismiss()
//            self?.navigationController.dismiss(animated: false) {
//                self?.requestCoordinating?()
//                self?.finishFlow?()
//            }
        }
        
//        rootViewController = dailySoptuneCard.vc
        dailySoptuneCard.vc.modalPresentationStyle = .overFullScreen
        rootViewController.present(dailySoptuneCard.vc, animated: true)
    }
}
