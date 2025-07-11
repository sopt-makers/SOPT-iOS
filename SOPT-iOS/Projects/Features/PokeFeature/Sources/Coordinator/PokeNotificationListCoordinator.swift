//
//  PokeNotificationListCoordinator.swift
//  PokeFeature
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface
import WebFeature

public final class PokeNotificationListCoordinator: DefaultCoordinator {
    
    // MARK: - Properties
    
    public var finishFlow: (() -> Void)?
    
    private let factory: PokeFeatureBuildable
    private let navigationController: UINavigationController
    private weak var rootController: UINavigationController?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: PokeFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showPokeNotificationListView()
    }
    
    // MARK: - Navigation
    
    private func showPokeNotificationListView() {
        var pokeNotiListVC = factory.makePokeNotificationList()
        
        pokeNotiListVC.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let bottomSheet = self?.factory
                .makePokeMessageTemplateBottomSheet(messageType: userModel.isFirstMeet ? .pokeSomeone : .pokeFriend)
                    .vc
                    .viewController as? PokeMessageTemplateBottomSheet
            else { return .empty() }
            
            let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate(minHeight: PokeMessageTemplateBottomSheet.minimumContentHeight))
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
            self?.navigationController.pushViewController(webView, animated: true)
        }
        
        let navController = UINavigationController(rootViewController: pokeNotiListVC.vc)
        rootController = navController
        
        var willAnimate = true
        if let top = navigationController.topViewController, type(of: top) == type(of: pokeNotiListVC.vc) {
            willAnimate = false
            navigationController.popViewController(animated: false)
        }
        
        navigationController.pushViewController(pokeNotiListVC.vc, animated: willAnimate)
    }
}
