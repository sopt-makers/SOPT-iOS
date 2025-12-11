//
//  PokeCoordinator.swift
//  PokeFeature
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface
import WebFeature

public final class PokeCoordinator: BaseCoordinator {

    // MARK: - Properties
    
    private let factory: PokeFeatureBuildable
    private weak var navigationController: UINavigationController?
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

    public func start(isRouteFromTabBar: Bool = false) {
        showPokeMain(isRouteFromRoot: isRouteFromTabBar, isRouteFromTabBar: isRouteFromTabBar)
    }
    public override func start() {
        start(isRouteFromTabBar: false)
    }
    
    // MARK: - Navigation

    public func showPokeMain(isRouteFromRoot: Bool, isRouteFromTabBar: Bool) {
        var pokeMain = factory.makePokeMain(isRouteFromRoot: isRouteFromRoot, isRouteFromTabBar: isRouteFromTabBar,  coordinator: self)

        if isRouteFromTabBar {
            self.rootController = self.navigationController
            self.navigationController?.setViewControllers([pokeMain.vc], animated: false)
        } else {
            let newNav = UINavigationController(rootViewController: pokeMain.vc)
            newNav.modalPresentationStyle = .overFullScreen
            self.rootController = newNav
            pokeMain.vm.onNaviBackTap = { [weak self] in
                self?.navigationController?.dismiss(animated: true)
            }

            self.navigationController?.present(newNav, animated: true)
        }
        
        pokeMain.vm.onPokeNotificationsTap = { [weak self] in
            self?.runPokeNotificationListFlow()
        }
        
        pokeMain.vm.onMyFriendsTap = { [weak self] in
            self?.runPokeMyFriendsFlow()
        }
        
        pokeMain.vm.onProfileImageTapped = { [weak self] userId in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(userId)") else { return }
            let webView = SOPTWebView(startWith: url)
            self?.rootController?.pushViewController(webView, animated: true)
        }
        
        pokeMain.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: self.rootController)
        }
        
        pokeMain.vm.onNewFriendMade = { [weak self] friendName in
            guard let self else { return }
            let pokeMakingFriendCompletedVC = self.factory.makePokeMakingFriendCompleted(friendName: friendName).viewController
            pokeMakingFriendCompletedVC.modalPresentationStyle = .overFullScreen
            self.rootController?.present(pokeMakingFriendCompletedVC, animated: false)
        }

        pokeMain.vm.onAnonymousFriendUpgrade = { [weak self] user in
            guard let self else { return }
            let pokeAnonymousFriendUpgradeVC = self.factory.makePokeAnonymousFriendUpgrade(user: user).viewController
            pokeAnonymousFriendUpgradeVC.modalPresentationStyle = .overFullScreen
            self.rootController?.present(pokeAnonymousFriendUpgradeVC, animated: false)
        }
    }
    
    internal func runPokeNotificationListFlow() {
        guard let navigationController = self.rootController else { return }

        let pokeNotificationListCoordinator = PokeNotificationListCoordinator(
            navigationController: navigationController,
            factory: factory
        )
        
        pokeNotificationListCoordinator.finishFlow = { [weak self, weak pokeNotificationListCoordinator] in
            pokeNotificationListCoordinator?.childCoordinators = []
            self?.removeDependency(pokeNotificationListCoordinator)
        }
        
        addDependency(pokeNotificationListCoordinator)
        pokeNotificationListCoordinator.start()
    }
    
    private func runPokeMyFriendsFlow() {
        guard let navigationController = self.rootController else { return }

        let pokeMyFriendsCoordinator = PokeMyFriendsCoordinator(
            navigationController: navigationController,
            factory: factory
        )
        
        pokeMyFriendsCoordinator.start()
    }
    
    private func showMessageBottomSheet(userModel: PokeUserModel, on view: UIViewController?) -> AnyPublisher<(PokeUserModel, PokeMessageModel, isAnonymous: Bool), Never> {
        let messageType: PokeMessageType = userModel.isFirstMeet ? .pokeSomeone : .pokeFriend

        guard let bottomSheet = self.factory
            .makePokeMessageTemplateBottomSheet(messageType: messageType)
            .vc
            .viewController as? PokeMessageTemplateBottomSheet
        else { return .empty() }
        
        let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate(minHeight: PokeMessageTemplateBottomSheet.minimumContentHeight))
        
        bottomSheetManager.present(toPresent: bottomSheet, on: view)
        
        return bottomSheet
            .signalForClick()
            .map { (userModel, $0, $1) }
            .asDriver()
    }
}
