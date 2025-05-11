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
import WebFeature

public final class PokeNotificationListCoordinator: DefaultCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let router: LegacyRouter
    private let factory: PokeFeatureBuildable
    private weak var rootController: UINavigationController?
    
    public init(router: LegacyRouter, factory: PokeFeatureBuildable) {
        self.router = router
        self.factory = factory
    }
    
    public override func start() {
        self.showPokeNotificationListView()
    }
}

extension PokeNotificationListCoordinator {
    private func showPokeNotificationListView() {
        var pokeNotiListVC = self.factory.makePokeNotificationList()
                    
        pokeNotiListVC.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let bottomSheet = self?.factory
                .makePokeMessageTemplateBottomSheet(messageType: userModel.isFirstMeet ? .pokeSomeone : .pokeFriend)
                    .vc
                    .viewController as? PokeMessageTemplateBottomSheet
            else { return .empty() }
            
            let bottomSheetManager = BottomSheetManager(configuration:  .messageTemplate(minHeight: PokeMessageTemplateBottomSheet.minimumContentHeight))
            bottomSheetManager.present(toPresent: bottomSheet, on: self?.rootController)
            
            return bottomSheet
                .signalForClick()
                .map { (userModel, $0, $1) }
                .asDriver()
        }
        
        pokeNotiListVC.vm.onNewFriendAdded = { [weak self] friendName in
            guard let self else { return }
            
            let pokeMakingFriendCompletedVC = self.factory.makePokeMakingFriendCompleted(friendName: friendName).viewController
            pokeMakingFriendCompletedVC.modalPresentationStyle = .overFullScreen
            self.rootController?.present(pokeMakingFriendCompletedVC, animated: false)
        }

        pokeNotiListVC.vm.onAnonymousFriendUpgrade = { [weak self] user in
            guard let self else { return }
            let pokeAnonymousFriendUpgradeVC = self.factory.makePokeAnonymousFriendUpgrade(user: user).viewController
            pokeAnonymousFriendUpgradeVC.modalPresentationStyle = .overFullScreen
            self.rootController?.present(pokeAnonymousFriendUpgradeVC, animated: false)
        }

        pokeNotiListVC.vm.onProfileImageTapped = { [weak self] playgroundId in
          guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(playgroundId)") else { return }

          let webView = SOPTWebView(startWith: url)

          self?.router.push(webView.viewController, transition: nil, animated: true)
        }

        self.rootController = pokeNotiListVC.vc.asNavigationController
        
        var willAnimate = true
        if let top = router.topViewController, type(of: top) == type(of: pokeNotiListVC.vc) {
            willAnimate = false
            router.popModule(transition: nil, animated: false)
        }
        
        self.router.push(pokeNotiListVC.vc, transition: nil, animated: willAnimate)
    }
}
