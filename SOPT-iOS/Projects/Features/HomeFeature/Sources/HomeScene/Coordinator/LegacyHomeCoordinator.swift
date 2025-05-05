//
//  LegacyHomeCoordinator.swift
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

public final class LegacyHomeCoordinator: DefaultHomeCoordinator {
    
    public var requestCoordinating: ((HomeCoordinatorDestination) -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: LegacyHomeFeatureBuildable
    private let router: LegacyRouter
    private let userType: UserType
    
    public private(set) var rootViewController: UIViewController?
    private weak var rootController: UINavigationController?
    
    public init(
        router: LegacyRouter,
        factory: LegacyHomeFeatureBuildable,
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
            self?.requestCoordinating?(.soptlog)
        }
        
        homeForMember.vm.onCalendarCellTapped = { [weak self] in
            self?.requestCoordinating?(.calendar)
        }

        homeForMember.vm.onNotificationButtonTapped = { [weak self] in
            self?.requestCoordinating?(.notification)
        }
        
        homeForMember.vm.onSettingButtonTapped = { [weak self] userType in
            self?.requestCoordinating?(.setting(userType: userType))
        }
        
        homeForMember.vm.onAppServiceCellTapped = { [weak self] url in
            self?.requestCoordinating?(.deepLink(url: url))
        }
        
        homeForMember.vm.onMainProductCellTapped = { [weak self] url in
            self?.requestCoordinating?(.webLink(url: url))
        }
        
        homeForMember.vm.onAttendanceButtonTapped = { [weak self] in
            self?.requestCoordinating?(.attendance)
        }
        
        homeForMember.vm.onNeedSignIn = { [weak self] in
            self?.requestCoordinating?(.signIn)
        }
    
        homeForMember.vm.onNetworkError = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        homeForMember.vm.onPoke = { [weak self] isNewUser in
            self?.requestCoordinating?(.poke(isNewUser: isNewUser))
        }
        
        rootViewController = homeForMember.vc.viewController
        
        router.push(homeForMember.vc)
    }
    
    public func showHomeForVisitor() {
        var homeForVisitor = factory.makeHomeForVisitor()
        
        homeForVisitor.vm.onAppServiceCellTapped = {
            AlertUtils.presentAlertVC(
                type: .titleDescription,
                title: I18N.Home.PopUp.needToLogin,
                description: I18N.Home.PopUp.needToLoginDetail,
                customButtonTitle: I18N.Home.PopUp.login,
                customAction: { [weak self] in
                    self?.requestCoordinating?(.signIn)
                }
            )
        }
        
        homeForVisitor.vm.onMainProductCellTapped = { [weak self] url in
            self?.requestCoordinating?(.webLink(url: url))
        }
        
        homeForVisitor.vm.onSettingButtonTapped = { [weak self] userType in
            self?.requestCoordinating?(.setting(userType: userType))
        }
        
        rootViewController = homeForVisitor.vc.viewController
        router.push(homeForVisitor.vc)
    }
}
