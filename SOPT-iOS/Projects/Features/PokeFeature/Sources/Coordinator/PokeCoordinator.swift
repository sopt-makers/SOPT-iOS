//
//  PokeCoordinator.swift
//  PokeFeature
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import BaseFeatureDependency
import PokeFeatureInterface
import Domain

public
final class PokeCoordinator: DefaultCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let factory: PokeFeatureBuildable
    private let router: Router
    private weak var rootController: UINavigationController?
    
    public init(router: Router, factory: PokeFeatureBuildable) {
        self.router = router
        self.factory = factory
    }
    
    public override func start() {
        showPokeMain(isRouteFromRoot: false)
    }
    
    public func showPokeMain(isRouteFromRoot: Bool) {
        var pokeMain = factory.makePokeMain(isRouteFromRoot: isRouteFromRoot)
        
        pokeMain.vm.onNaviBackTap = { [weak self] in
            self?.router.dismissModule(animated: true)
            self?.finishFlow?()
        }
        
        pokeMain.vm.onPokeNotificationsTap = { [weak self] in
            self?.runPokeNotificationListFlow()
        }
        
        pokeMain.vm.onMyFriendsTap = { [weak self] in
            self?.runPokeMyFriendsFlow()
        }
        
        pokeMain.vm.onProfileImageTapped = { [weak self] playgroundId in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(playgroundId)") else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.rootController?.pushViewController(webView, animated: true)
        }
        
        pokeMain.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: pokeMain.vc.viewController)
        }
        
        pokeMain.vm.onNewFriendMade = { [weak self] friendName in
            guard let self else { return }
            let pokeMakingFriendCompletedVC = self.factory.makePokeMakingFriendCompleted(friendName: friendName).viewController
            pokeMakingFriendCompletedVC.modalPresentationStyle = .overFullScreen
            pokeMain.vc.viewController.present(pokeMakingFriendCompletedVC, animated: false)
        }

        pokeMain.vm.onAnonymousFriendUpgrade = { [weak self] user in
          guard let self else { return }
          let pokeAnonymousFriendUpgradeVC = self.factory.makePokeAnonymousFriendUpgrade(user: user).viewController
          pokeAnonymousFriendUpgradeVC.modalPresentationStyle = .overFullScreen
          pokeMain.vc.viewController.present(pokeAnonymousFriendUpgradeVC, animated: false)
        }

        pokeMain.vm.switchToOnboarding = { [weak self] in
            guard let self = self else { return }
            self.runPokeOnboardingFlow()
        }
        
        rootController = pokeMain.vc.asNavigationController
        router.present(rootController, animated: true, modalPresentationSytle: .overFullScreen)
    }
    
    internal func runPokeOnboardingFlow() {
        let pokeOnboardingCoordinator = PokeOnboardingCoordinator(
            router: Router(
                rootController: rootController ?? self.router.asNavigationController
            ),
            factory: factory
        )
        
        pokeOnboardingCoordinator.finishFlow = { [weak self, weak pokeOnboardingCoordinator] in
            pokeOnboardingCoordinator?.childCoordinators = []
            self?.removeDependency(pokeOnboardingCoordinator)
        }
        
        addDependency(pokeOnboardingCoordinator)
        pokeOnboardingCoordinator.switchToPokeOnboardingView()
    }
    
    internal func runPokeNotificationListFlow() {
        let pokeNotificationListCoordinator = PokeNotificationListCoordinator(
            router: Router(
                rootController: rootController ?? self.router.asNavigationController
            ),
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
        let pokeMyFriendsCoordinator = PokeMyFriendsCoordinator(factory: factory,
                                                                router: Router(rootController: rootController!))
        
        pokeMyFriendsCoordinator.finishFlow = { [weak self, weak pokeMyFriendsCoordinator] in
            self?.removeDependency(pokeMyFriendsCoordinator)
        }
        
        addDependency(pokeMyFriendsCoordinator)
        pokeMyFriendsCoordinator.start()
    }
    
    private func showMessageBottomSheet(userModel: PokeUserModel, on view: UIViewController?) -> AnyPublisher<(PokeUserModel, PokeMessageModel, isAnonymous: Bool), Never> {
        let messageType: PokeMessageType = userModel.isFirstMeet ? .pokeSomeone : .pokeFriend

        guard let bottomSheet = self.factory
            .makePokeMessageTemplateBottomSheet(messageType: messageType)
                .vc
                .viewController as? PokeMessageTemplateBottomSheet
        else { return .empty() }
        
        let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate())
        
        self.router.showBottomSheet(manager: bottomSheetManager,
                                     toPresent: bottomSheet,
                                     on: view)
        
        return bottomSheet
            .signalForClick()
            .map { (userModel, $0, $1) }
            .asDriver()
    }
}
