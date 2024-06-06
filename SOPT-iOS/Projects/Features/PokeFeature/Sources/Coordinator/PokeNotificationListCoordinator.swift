//
//  PokeNotificationListCoordinator.swift
//  PokeFeature
//
//  Created by Ian on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface

public final class PokeNotificationListCoordinator: DefaultCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let router: Router
    private let factory: PokeFeatureBuildable
    private weak var rootController: UINavigationController?
    
    public init(router: Router, factory: PokeFeatureBuildable) {
        self.router = router
        self.factory = factory
    }
    
    public override func start() {
        self.showPokeNotificationListView()
    }
}

extension PokeNotificationListCoordinator {
    private func showPokeNotificationListView() {
        var viewController = self.factory.makePokeNotificationList()
                    
        viewController.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let bottomSheet = self?.factory
                .makePokeMessageTemplateBottomSheet(messageType: userModel.isFirstMeet ? .pokeSomeone : .pokeFriend)
                    .vc
                    .viewController as? PokeMessageTemplateBottomSheet
            else { return .empty() }
            
            let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate())
            bottomSheetManager.present(toPresent: bottomSheet, on: self?.rootController)
            
            return bottomSheet
                .signalForClick()
                .map { (userModel, $0, $1) }
                .asDriver()
        }
        
        viewController.vm.onNewFriendAdded = { [weak self] friendName in
            guard let self else { return }
            
            let pokeMakingFriendCompletedVC = self.factory.makePokeMakingFriendCompleted(friendName: friendName).viewController
            pokeMakingFriendCompletedVC.modalPresentationStyle = .overFullScreen
            viewController.vc.viewController.present(pokeMakingFriendCompletedVC, animated: false)
        }

        viewController.vm.onAnonymousFriendUpgrade = { [weak self] user in
            guard let self else { return }
            let pokeAnonymousFriendUpgradeVC = self.factory.makePokeAnonymousFriendUpgrade(user: user).viewController
            pokeAnonymousFriendUpgradeVC.modalPresentationStyle = .overFullScreen
            viewController.vc.viewController.present(pokeAnonymousFriendUpgradeVC, animated: false)
        }

        self.rootController = viewController.vc.asNavigationController
        
        var willAnimate = true
        if let top = router.topViewController, type(of: top) == type(of: viewController.vc) {
            willAnimate = false
            router.popModule(transition: nil, animated: false)
        }
        
        self.router.push(viewController.vc, transition: nil, animated: willAnimate)
    }
}
