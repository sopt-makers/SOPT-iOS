//
//  PokeCoordinator.swift
//  PokeFeature
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

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
        showPokeMain()
    }
    
    private func showPokeMain() {
        var pokeMain = factory.makePokeMain()
        
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
        
        rootController = pokeMain.vc.asNavigationController
        router.present(rootController, animated: true, modalPresentationSytle: .overFullScreen)
    }
    
    private func runPokeNotificationListFlow() {
        let pokeNotificationListCoordinator = PokeNotificationListCoordinator(
            router: Router(
                rootController: rootController!
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
}
