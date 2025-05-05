//
//  HomeCoordinator.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 5/5/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain

import BaseFeatureDependency
import HomeFeatureInterface
import WebFeature

public protocol HomeCoordinatorDelegate: AnyObject {
    func homeCoordinator(_ coordinator: HomeCoordinator, didRequest destination: HomeCoordinatorDestination)
}

public final class HomeCoordinator: DefaultHomeCoordinator {
    
    public weak var delegate: HomeCoordinatorDelegate?
    
    // MARK: - Properties
    
    public var requestCoordinating: ((HomeCoordinatorDestination) -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: HomeFeatureBuildable
    private let userType: UserType
    private let navigationController: UINavigationController
    
    public private(set) var rootViewController: UIViewController?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: HomeFeatureBuildable,
        userType: UserType
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.userType = userType
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        switch userType {
        case .visitor:
            showHomeForVisitor()
        case .active, .inactive:
            showHomeForMember()
        }
    }
    
    // MARK: - Navigation
    
    public func showHomeForMember() {
        var homeForMember = factory.makeHomeForMember()
        
        homeForMember.vm.onDashBoardCellTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .soptlog)
        }
        
        homeForMember.vm.onCalendarCellTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .calendar)
        }

        homeForMember.vm.onNotificationButtonTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .notification)
        }
        
        homeForMember.vm.onSettingButtonTapped = { [weak self] userType in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .setting(userType: userType))
        }
        
        homeForMember.vm.onAppServiceCellTapped = { [weak self] url in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .deepLink(url: url))
        }
        
        homeForMember.vm.onMainProductCellTapped = { [weak self] url in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .webLink(url: url))
        }
        
        homeForMember.vm.onAttendanceButtonTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .attendance)
        }
        
        homeForMember.vm.onNeedSignIn = { [weak self] in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .signIn)
        }
    
        homeForMember.vm.onNetworkError = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        homeForMember.vm.onPoke = { [weak self] isNewUser in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .poke(isNewUser: isNewUser))
        }
        
        rootViewController = homeForMember.vc.viewController
        navigationController.pushViewController(homeForMember.vc.viewController, animated: true)
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
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .webLink(url: url))
        }
        
        homeForVisitor.vm.onSettingButtonTapped = { [weak self] userType in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, didRequest: .setting(userType: userType))
        }
        
        rootViewController = homeForVisitor.vc.viewController
        navigationController.pushViewController(homeForVisitor.vc.viewController, animated: true)
    }
}
