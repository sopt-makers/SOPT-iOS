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
        var viewController = self.factory.makePokeNotificationList()
                    
        viewController.vm.onPokeButtonTapped = { [weak self] userModel in
            guard let bottomSheet = self?.factory
                .makePokeMessageTemplateBottomSheet(messageType: .pokeSomeone)
                    .vc
                    .viewController as? PokeMessageTemplateBottomSheet
            else { return .empty() }
            
            let bottomSheetManager = BottomSheetManager(configuration: .messageTemplate())
            bottomSheetManager.present(toPresent: bottomSheet, on: self?.rootController)
            
            return bottomSheet
                .signalForClick()
                .map { (userModel, $0) }
                .asDriver()
        }
        
        self.rootController = viewController.vc.asNavigationController
        self.router.push(viewController.vc)
    }
}
