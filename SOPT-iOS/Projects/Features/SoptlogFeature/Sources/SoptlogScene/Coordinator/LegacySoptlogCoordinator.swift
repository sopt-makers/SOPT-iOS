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
