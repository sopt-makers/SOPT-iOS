//
//  SoptlogCoordinator.swift
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

public enum SoptlogCoordinatorDestination {
    case dailySoptune
    case signIn
    case webLink(url: String)
}

public final class SoptlogCoordinator: DefaultCoordinator {
    
    public var requestCoordinating: ((SoptlogCoordinatorDestination) -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: SoptlogFeatureBuildable
    private let router: LegacyRouter
    private let userType: UserType
    
    private weak var rootController: UINavigationController?
    public private(set) var rootViewController: UIViewController?
    
    public init(router: LegacyRouter, factory: SoptlogFeatureBuildable, userType: UserType) {
        self.router = router
        self.factory = factory
        self.userType = userType
    }
    
    public override func start() {
        switch userType {
        case .visitor:
            self.rootViewController = UIViewController()
        case .active, .inactive:
            showSoptlog()
        }
    }
    
    private func showSoptlog() {
        var soptlog = factory.makeSoptlog()
        
        soptlog.vm.onProfileEditTapped = { [weak self] in
            let url = "\(ExternalURL.Playground.main)/members/edit"
            self?.requestCoordinating?(.webLink(url: url))
        }
        
        soptlog.vm.onToolTipTapped = { [weak self] toolTipFrame in
            self?.showToolTip(toolTipFrame)
        }
        
        soptlog.vm.onSoptuneTapped = { [weak self] in
            self?.requestCoordinating?(.dailySoptune)
        }
        
        soptlog.vm.onNetworkError = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        soptlog.vm.onNeedSignIn = { [weak self] in
            self?.requestCoordinating?(.signIn)
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
