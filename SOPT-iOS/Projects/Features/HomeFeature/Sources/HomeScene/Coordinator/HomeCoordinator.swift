//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 11/22/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain

import BaseFeatureDependency
import HomeFeatureInterface
import WebFeature

public final class HomeCoordinator: DefaultCoordinator {
    
    public var finishFlow: (() -> Void)?
    
    private let factory: HomeFeatureBuildable
    private let router: Router
    private let userType: UserType
    
    public init(
        router: Router,
        factory: HomeFeatureBuildable,
        userType: UserType
    ) {
        self.router = router
        self.factory = factory
        self.userType = userType
    }
    
    public override func start() {
        switch userType {
        case .visitor:
            showHomeForVisitor()
        case .active, .inactive:
            showHomeForMember()
        }
    }
    
    public func showHomeForMember() {
        var homeForMember = factory.makeHomeForMember()
        
        homeForMember.vm.onDashBoardCellTapped = { [weak self] in
            let homeCalendarDetail = self?.factory.makeHomeCalendarDetail()
            self?.router.push(homeCalendarDetail?.vc)
        }
    
        router.replaceRootWindow(homeForMember.vc, withAnimation: true)
    }
    
    public func showHomeForVisitor() {
        var homeForVisitor = factory.makeHomeForVisitor()
        
        router.replaceRootWindow(homeForVisitor.vc, withAnimation: true)
    }
}

