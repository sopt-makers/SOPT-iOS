//
//  SoptlogCoordinator.swift
//  SoptlogFeature
//
//  Created by Jae Hyun Lee on 5/5/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import Domain

import BaseFeatureDependency
import SoptlogFeatureInterface
import WebFeature

public protocol SoptlogCoordinatorDelegate: AnyObject {
    func soptlogCoordinator(_ coordinator: SoptlogCoordinator, didRequest destination: SoptlogCoordinatorDestination)
}

public final class SoptlogCoordinator: DefaultSoptlogCoordinator {
    
    public weak var delegate: SoptlogCoordinatorDelegate?
    
    // MARK: - Properties
    
    public var requestCoordinating: ((SoptlogCoordinatorDestination) -> Void)?
    public var finishFlow: (() -> Void)?
    
    private let factory: SoptlogFeatureBuildable
    private let userType: UserType
    private let navigationController: UINavigationController
    
    public private(set) var rootViewController: UIViewController?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: SoptlogFeatureBuildable,
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
            self.rootViewController = UIViewController()
        case .active, .inactive:
            showSoptlog()
        }
    }
    
    // MARK: - Navigation
    
    private func showSoptlog() {
        var soptlog = factory.makeSoptlog()
        
        soptlog.vm.onProfileEditTapped = { [weak self] in
            guard let self else { return }
            let url = "\(ExternalURL.Playground.main)/members/edit"
            self.delegate?.soptlogCoordinator(self, didRequest: .webLink(url: url))
        }
        
        soptlog.vm.onToolTipTapped = { [weak self] toolTipFrame in
            guard let self else { return }
            self.showToolTip(toolTipFrame)
        }
        
        soptlog.vm.onSoptuneTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.soptlogCoordinator(self, didRequest: .dailySoptune)
        }
        
        soptlog.vm.onNetworkError = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        soptlog.vm.onNeedSignIn = { [weak self] in
            guard let self else { return }
            self.delegate?.soptlogCoordinator(self, didRequest: .signIn)
        }
        
        self.rootViewController = soptlog.vc
        navigationController.pushViewController(soptlog.vc, animated: true)
    }
    
    private func showToolTip(_ frame: CGRect) {
        var soptlogToolTip = factory.makeSoptlogToolTip(frame)
        
        soptlogToolTip.vm.onDismissButtonTap = { [weak self] in
            self?.rootViewController?.dismiss(animated: true)
        }
        
        soptlogToolTip.vm.onDimmingBackgroundTap = { [weak self] in
            self?.rootViewController?.dismiss(animated: true)
        }
        
        soptlogToolTip.vc.modalPresentationStyle = .overFullScreen
        soptlogToolTip.vc.modalTransitionStyle = .crossDissolve
        self.rootViewController?.present(soptlogToolTip.vc, animated: true)
    }
}
