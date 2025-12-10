//
//  PokeMyFriendsCoordinator.swift
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

public final class PokeMyFriendsCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    private let factory: PokeFeatureBuildable
    private let navigationController: UINavigationController
    private weak var rootController: UINavigationController?
    private var initialRelation: PokeRelation?
    
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
        showPokeMyFriends(initialRelation: nil)
    }
    
    public func start(with relation: PokeRelation) {
        self.initialRelation = relation
        showPokeMyFriends(initialRelation: relation)
    }
    
    // MARK: - Navigation
    
    private func showPokeMyFriends(initialRelation: PokeRelation?) {
        var pokeMyFriends = factory.makePokeMyFriends(coordinator: self)
        
        pokeMyFriends.vm.showFriendsListButtonTap = { [weak self] relation in
            self?.showFriendsList(with: relation)
        }
        
        pokeMyFriends.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: self.rootController)
        }
        
        pokeMyFriends.vm.onProfileImageTapped = { [weak self] userId in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(userId)") else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.navigationController.pushViewController(webView, animated: true)
        }
        
        pokeMyFriends.vm.onAnonymousFriendUpgrade = { [weak self] user in
            guard let self else { return }
            let pokeAnonymousFriendUpgradeVC = self.factory.makePokeAnonymousFriendUpgrade(user: user).viewController
            pokeAnonymousFriendUpgradeVC.modalPresentationStyle = .overFullScreen
            self.navigationController.present(pokeAnonymousFriendUpgradeVC, animated: false)
        }

        if let relation = initialRelation {
            self.showFriendsList(with: relation)
        }
        
        navigationController.pushViewController(pokeMyFriends.vc, animated: true)
    }
    
    private func showFriendsList(with relation: PokeRelation) {
        var pokeMyFriendsList = factory.makePokeMyFriendsList(relation: relation)
        
        pokeMyFriendsList.vm.onCloseButtonTap = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        
        pokeMyFriendsList.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let self else { return .empty() }
            return self.showMessageBottomSheet(userModel: userModel, on: self.rootController)
        }
        
        pokeMyFriendsList.vm.onProfileImageTapped = { [weak self] userId in
            guard let url = URL(string: "\(ExternalURL.Playground.main)/members/\(userId)") else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.rootController?.pushViewController(webView, animated: true)
        }
        
        pokeMyFriendsList.vm.onAnonymousFriendUpgrade = { [weak self] user in
            guard let self else { return }
            let pokeAnonymousFriendUpgradeVC = self.factory.makePokeAnonymousFriendUpgrade(user: user).viewController
            pokeAnonymousFriendUpgradeVC.modalPresentationStyle = .overFullScreen
            self.navigationController.present(pokeAnonymousFriendUpgradeVC, animated: false)
        }
        
        let navController = UINavigationController(rootViewController: pokeMyFriendsList.vc)
        rootController = navController
        navigationController.present(navController, animated: true)
    }
    
    private func showMessageBottomSheet(userModel: PokeUserModel, on view: UIViewController?) -> AnyPublisher<(PokeUserModel, PokeMessageModel, isAnonymous: Bool), Never> {
        guard let bottomSheet = self.factory
            .makePokeMessageTemplateBottomSheet(messageType: .pokeFriend)
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
