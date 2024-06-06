//
//  PokeMyFriendsCoordinator.swift
//  PokeFeature
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface

public
final class PokeMyFriendsCoordinator: DefaultCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let factory: PokeFeatureBuildable
    private let router: Router
    private weak var rootController: UINavigationController?
    
    public init(factory: PokeFeatureBuildable, router: Router) {
        self.factory = factory
        self.router = router
    }
    
    public override func start() {
        showPokeMyFriends()
    }
    
    private func showPokeMyFriends() {
        var pokeMyFriends = factory.makePokeMyFriends()
        
        pokeMyFriends.vm.showFriendsListButtonTap = { [weak self] relation in
            self?.showPokeMyFriendsList(with: relation)
        }
        
        pokeMyFriends.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: pokeMyFriends.vc.viewController)
        }
        
        pokeMyFriends.vm.onProfileImageTapped = { [weak self] playgroundId in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(playgroundId)") else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.router.push(webView)
        }

        pokeMyFriends.vm.onAnonymousFriendUpgrade = { [weak self] user in
          guard let self else { return }
          let pokeAnonymousFriendUpgradeVC = self.factory.makePokeAnonymousFriendUpgrade(user: user).viewController
          pokeAnonymousFriendUpgradeVC.modalPresentationStyle = .overFullScreen
          pokeMyFriends.vc.viewController.present(pokeAnonymousFriendUpgradeVC, animated: false)
        }

        router.push(pokeMyFriends.vc)
    }
    
    private func showPokeMyFriendsList(with relation: PokeRelation) {
        var pokeMyFriendsList = factory.makePokeMyFriendsList(relation: relation)
        
        pokeMyFriendsList.vm.onCloseButtonTap = { [weak self] in 
            self?.router.dismissModule(animated: true)
        }
        
        pokeMyFriendsList.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: pokeMyFriendsList.vc.viewController)
        }
        
        pokeMyFriendsList.vm.onProfileImageTapped = { [weak self] playgroundId in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(playgroundId)") else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.rootController?.pushViewController(webView, animated: true)
        }

        pokeMyFriendsList.vm.onAnonymousFriendUpgrade = { [weak self] user in
          guard let self else { return }
          let pokeAnonymousFriendUpgradeVC = self.factory.makePokeAnonymousFriendUpgrade(user: user).viewController
          pokeAnonymousFriendUpgradeVC.modalPresentationStyle = .overFullScreen
          pokeMyFriendsList.vc.viewController.present(pokeAnonymousFriendUpgradeVC, animated: false)
        }

        self.rootController = pokeMyFriendsList.vc.asNavigationController
        router.present(rootController, animated: true)
    }
    
    private func showMessageBottomSheet(userModel: PokeUserModel, on view: UIViewController?) -> AnyPublisher<(PokeUserModel, PokeMessageModel, isAnonymous: Bool), Never> {
        guard let bottomSheet = self.factory
            .makePokeMessageTemplateBottomSheet(messageType: .pokeFriend)
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
