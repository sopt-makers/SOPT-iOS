//
//  PokeMyFriendsCoordinator.swift
//  PokeFeature
//
//  Created by sejin on 12/14/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency
import PokeFeatureInterface

public
final class PokeMyFriendsCoordinator: DefaultCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let factory: PokeFeatureBuildable
    private let router: Router
    
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
        
        router.push(pokeMyFriends.vc)
    }
    
    private func showPokeMyFriendsList(with relation: PokeRelation) {
        let pokeMyFriendsList = factory.makePokeMyFriendsList(relation: relation)
        
        router.present(pokeMyFriendsList.vc, animated: true)
    }
}
