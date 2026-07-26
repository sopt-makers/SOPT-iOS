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
    func soptlogCoordinator(_ coordinator: SoptlogCoordinator, to destination: SoptlogCoordinatorDestination)
}

public final class SoptlogCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    private let factory: SoptlogFeatureBuildable
    public weak var delegate: SoptlogCoordinatorDelegate?
    private weak var navigationController: UINavigationController?
    public private(set) weak var rootViewController: UIViewController?
    
    // MARK: - Init
    
    public init(
        navigationController: UINavigationController,
        factory: SoptlogFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Coordinator Life Cycle
    
    public override func start() {
        showSoptlog()
    }
    
    // MARK: - Navigation
    
    private func showSoptlog() {
        var soptlog = factory.makeSoptlog(coordinator: self)
        
        soptlog.vm.onToolTipTapped = { [weak self] toolTipFrame in
            guard let self else { return }
            self.showToolTip(toolTipFrame)
        }
        
//        soptlog.vm.onSoptuneTapped = { [weak self] in
//            guard let self else { return }
//            self.delegate?.soptlogCoordinator(self, to: .dailySoptune)
//        }
        
        soptlog.vm.onSoptampHomeTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.soptlogCoordinator(self, to: .soptamp)
        }
        
        soptlog.vm.onPokeHomeTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.soptlogCoordinator(self, to: .pokeHome)
        }
        
        soptlog.vm.onPokeMyFriendsTapped = { [weak self] relation in
            guard let self else { return }
            self.delegate?.soptlogCoordinator(self, to: .pokeMyFriends(relation: relation))
        }
        
        soptlog.vm.onNetworkError = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        soptlog.vm.onAuthFailed = { [weak self] in
            AlertUtils.presentAlertVC(
                type: .titleDescription,
                title: I18N.Home.PopUp.needToLogin,
                description: I18N.Home.PopUp.needToLoginDetail,
                customButtonTitle: I18N.Home.PopUp.login,
                customAction: { [weak self] in
                    guard let self else { return }
                    self.delegate?.soptlogCoordinator(self, to: .signIn)
                },
                cancelAction: { [weak self] in
                    guard let self else { return }
                    self.delegate?.soptlogCoordinator(self, to: .home)
                }
            )
        }
        
        self.rootViewController = soptlog.vc
        navigationController?.pushViewController(soptlog.vc, animated: true)
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
