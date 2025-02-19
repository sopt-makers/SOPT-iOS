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

public enum HomeCoordinatorDestination {
    case signIn
    case notification
    case setting(userType: UserType)
    case attendance
    case soptlog
    
    case webLink(url: String)
    case deepLink(url: String)
}

public protocol HomeCoordinatorOutput {
    var requestCoordinating: ((HomeCoordinatorDestination) -> Void)? { get set }
}

public typealias DefaultHomeCoordinator = BaseCoordinator & HomeCoordinatorOutput

public final class HomeCoordinator: DefaultCoordinator {
    
    public var requestCoordinating: ((HomeCoordinatorDestination) -> Void)?
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
            self?.requestCoordinating?(.soptlog)
        }
        
        homeForMember.vm.onCalendarCellTapped = { [weak self] in
            self?.showHomeCalendarDetail()
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
    
        router.replaceRootWindow(homeForMember.vc, withAnimation: true)
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
        
        router.replaceRootWindow(homeForVisitor.vc, withAnimation: true)
    }
    
    public func showHomeCalendarDetail() {
        var homeCalendarDetail = factory.makeHomeCalendarDetail()
        
        homeCalendarDetail.vm.onNaviBackButtonTap = { [weak self] in
            self?.router.popModule()
        }
        
        homeCalendarDetail.vm.onAttendanceButtonTap = { [weak self] in
            self?.requestCoordinating?(.attendance)
        }
        
        self.router.push(homeCalendarDetail.vc)
    }
}
