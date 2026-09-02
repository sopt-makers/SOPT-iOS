//
//  LegacySoptlogCoordinator.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain

import BaseFeatureDependency
import SoptlogFeatureInterface
import WebFeature

public final class LegacySoptlogCoordinator: DefaultSoptlogCoordinator {
    
    // MARK: - Properties
    
    public var requestCoordinating: ((SoptlogCoordinatorDestination) -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: LegacySoptlogFeatureBuildable
    private let router: LegacyRouter
    private let userType: UserType
    
    private weak var rootController: UINavigationController?
    public private(set) var rootViewController: UIViewController?
    
    // MARK: - Init
    
    public init(router: LegacyRouter, factory: LegacySoptlogFeatureBuildable, userType: UserType) {
        self.router = router
        self.factory = factory
        self.userType = userType
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        switch userType {
        case .visitor:
            self.rootViewController = UIViewController()
        case .active, .inactive:
            showSoptlog()
        }
    }
    
    // MARK: - Navigation
    
    private func showSoptlog() {
        var soptlog = factory.makeSoptlog(coordinator: self)
        
        soptlog.vm.onToolTipTapped = { [weak self] toolTipFrame in
            self?.showToolTip(toolTipFrame)
        }

        soptlog.vm.onNetworkError = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        soptlog.vm.onAuthFailed = { [weak self] in
            AlertUtils.presentAlertVC(
                type: .default(primary: .init(I18N.Home.PopUp.login)),
                title: I18N.Home.PopUp.needToLogin,
                description: I18N.Home.PopUp.needToLoginDetail,
                customAction: { [weak self] in
                    self?.requestCoordinating?(.signIn)
                },
                cancelAction: { [weak self] in
                    self?.requestCoordinating?(.home)
                }
            )
        }
        
        self.rootViewController = soptlog.vc.viewController
        self.router.push(soptlog.vc)
    }
    
    private func showToolTip(_ frame: CGRect) {
        var soptlogToolTip = factory.makeSoptlogToolTip(frame)
        
        soptlogToolTip.vm.onDismissButtonTap = { [weak self] in
            self?.rootViewController?.dismiss(animated: true)
        }
        
        soptlogToolTip.vm.onDimmingBackgroundTap = { [weak self] in
            self?.rootViewController?.dismiss(animated: true)
        }
        
        soptlogToolTip.vc.viewController.modalPresentationStyle = .overFullScreen
        soptlogToolTip.vc.viewController.modalTransitionStyle = .crossDissolve
        self.rootViewController?.present(soptlogToolTip.vc.viewController, animated: true)
    }
}
