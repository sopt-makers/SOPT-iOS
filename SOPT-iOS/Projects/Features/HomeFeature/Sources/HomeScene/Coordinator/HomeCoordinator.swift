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
    func homeCoordinator(_ coordinator: HomeCoordinator, to destination: HomeCoordinatorDestination)
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
            self.delegate?.homeCoordinator(self, to: .soptlog)
        }
        
        homeForMember.vm.onCalendarCellTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, to: .calendar)
        }

        homeForMember.vm.onNotificationButtonTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, to: .notification)
        }
        
        homeForMember.vm.onSettingButtonTapped = { [weak self] userType in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, to: .setting(userType: userType))
        }
        
        homeForMember.vm.onAppServiceCellTapped = { [weak self] url in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, to: .deepLink(url: url))
        }
        
        homeForMember.vm.onMainProductCellTapped = { [weak self] url in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, to: .webLink(url: url))
        }
        
        homeForMember.vm.onAttendanceButtonTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, to: .attendance)
        }
        
        homeForMember.vm.onNeedSignIn = { [weak self] in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, to: .signIn)
        }
    
        homeForMember.vm.onNetworkError = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        homeForMember.vm.onPoke = { [weak self] isNewUser in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, to: .poke(isNewUser: isNewUser))
        }
        
        homeForMember.vm.onExtendedFloatingButtonTapped = { [weak self] url in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, to: .deepLink(url: url))
        }
        
        rootViewController = homeForMember.vc
        navigationController.pushViewController(homeForMember.vc, animated: true)
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
            self.delegate?.homeCoordinator(self, to: .webLink(url: url))
        }
        
        homeForVisitor.vm.onSettingButtonTapped = { [weak self] userType in
            guard let self else { return }
            self.delegate?.homeCoordinator(self, to: .setting(userType: userType))
        }
        
        rootViewController = homeForVisitor.vc
        navigationController.pushViewController(homeForVisitor.vc, animated: true)
    }
}
