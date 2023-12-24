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
        let viewController = self.factory.makePokeNotificationList()
     
        self.rootController = viewController.vc.asNavigationController
        self.router.push(viewController.vc)
    }
}
