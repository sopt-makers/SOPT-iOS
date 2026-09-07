//
//  LegacyPokeCoordinator.swift
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
import WebFeature

public
final class LegacyPokeCoordinator: BaseCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let factory: LegacyPokeFeatureBuildable
    private let router: LegacyRouter
    private weak var rootController: UINavigationController?
    
    public init(router: LegacyRouter, factory: LegacyPokeFeatureBuildable) {
        self.router = router
        self.factory = factory
    }
    
    public override func start() {
        showPokeMain(isRouteFromRoot: false)
    }
    
    public func showPokeMain(isRouteFromRoot: Bool) {
        var pokeMain = factory.makePokeMain(isRouteFromRoot: isRouteFromRoot, coordinator: self)
        
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
        
        rootController = pokeMain.vc.asNavigationController
        router.present(rootController, animated: true, modalPresentationSytle: .overFullScreen)
    }
    
    internal func runPokeNotificationListFlow() {
        let pokeNotificationListCoordinator = LegacyPokeNotificationListCoordinator(
            router: LegacyRouter(
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
        let pokeMyFriendsCoordinator = LegacyPokeMyFriendsCoordinator(factory: factory,
                                                                router: LegacyRouter(rootController: rootController!))
        
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
        
        let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate(minHeight: PokeMessageTemplateBottomSheet.minimumContentHeight))
        
        self.router.showBottomSheet(manager: bottomSheetManager,
                                     toPresent: bottomSheet,
                                     on: view)
        
        return bottomSheet
            .signalForClick()
            .map { (userModel, $0, $1) }
            .asDriver()
    }
}
