//
//  TestApplicationCoordinator.swift
//  RootFeature
//
//  Created by Jae Hyun Lee on 3/13/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import SplashFeature
import AuthFeature
import TabBarFeature

public final class TestApplicationCoordinator: TestBaseCoordinator {

    public var finishFlow: (() -> Void)?
    
    private let navigationController: UINavigationController
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
        super.init()
    }
    
    public override func start() {
        runSplashFlow()
    }
}

// MARK: - SplashFlow

extension TestApplicationCoordinator {
    private func runSplashFlow() {
        let coordinator = TestSplashCoordinator(
            navigationController: self.navigationController,
            factory: SplashBuilder()
        )
        
        coordinator.stop = { [weak self, weak coordinator] in
            self?.checkDidSignIn()
            self?.removeTestDependency(coordinator)
        }

        addTestDependency(coordinator)
        // 강한 참조를 유지시키지 말고
        coordinator.start()
    }
    
    private func checkDidSignIn() {
//        runTabBarFlow()
    }
}

