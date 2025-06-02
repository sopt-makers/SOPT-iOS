//
//  StampGuideCoordinator.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import StampFeatureInterface

public final class StampGuideCoordinator: DefaultCoordinator {
    
    // MARK: - Properties
    
    public var finishFlow: (() -> Void)?
    
    private let factory: StampFeatureBuildable
    private let navigationController: UINavigationController
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: StampFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showGuide()
    }
    
    // MARK: - Navigation
    
    private func showGuide() {
        let guide = factory.makeStampGuideVC()
        
        guide.onNaviBackTap = { [weak self] in
            guard let self else { return }
            self.navigationController.popViewController(animated: true)
            self.finishFlow?()
        }
        
        navigationController.pushViewController(guide, animated: true)
    }
}
