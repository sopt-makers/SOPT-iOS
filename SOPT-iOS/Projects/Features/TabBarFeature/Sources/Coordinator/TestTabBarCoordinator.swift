//
//  TestTabBarCoordinator.swift
//  TabBarFeature
//
//  Created by Jae Hyun Lee on 3/13/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import HomeFeature
import AppMyPageFeature
import NotificationFeature
import StampFeature
import PokeFeature
import AttendanceFeature
import DailySoptuneFeature
import SoptlogFeature
import WebFeature

public final class TestTabBarCoordinator: DefaultCoordinator {
    public var finishFlow: (() -> Void)?
    
    private let factory: TabBarBuildable
    private var navigationController: UINavigationController
    
    public init(
        navigationController: UINavigationController,
        factory: TabBarBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    public override func start() {
        showTabBar()
    }
    
    private func showTabBar() {
        
    }
    
    // home
    private func runHomeFlow() {
        
    }
    
    // soptlog
    private func runSoptlogFlow() {
        
    }
}
