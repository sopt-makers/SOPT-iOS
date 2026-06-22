//
//  SoptletterCoordinator.swift
//  SoptletterFeature
//
//  Created by 강윤서 on 5/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import Core
import BaseFeatureDependency
import SoptletterFeatureInterface

public final class SoptletterCoordinator: DefaultCoordinator {

    // MARK: - Properties

    public var finishFlow: (() -> Void)?

    private let factory: SoptletterFeatureBuildable
    private let navigationController: UINavigationController
    private weak var rootController: UINavigationController?

    // MARK: - Init

    public init(
        navigationController: UINavigationController,
        factory: SoptletterFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    private var currentNavigationController: UINavigationController {
        rootController ?? navigationController
    }

    // MARK: - Coordinator Life Cycle

    public override func start() {
        showSoptletterWriting()
    }

    public func startOnboarding() {
        showSoptletterOnboarding()
    }

    // MARK: - Navigation
    private func showSoptletterOnboarding() {
        let soptletterOnboarding = factory.makeSoptletterOnboardingVC(coordinator: self)
        let navigationController = UINavigationController(rootViewController: soptletterOnboarding)
        navigationController.setNavigationBarHidden(true, animated: false)
        rootController = navigationController

        soptletterOnboarding.onStartButtonTap = { [weak self] in
            self?.showSoptletterCheckNickname()
        }
        
        soptletterOnboarding.onNaviBackTap = { [weak self] in
            self?.dismissFlow()
        }

        self.navigationController.present(navigationController, animated: true)
    }
    
    private func showSoptletterCheckNickname() {
        let vc = factory.makeSoptletterNicknameCheckVC(coordinator: self)
        
        vc.onNaviBackTap = { [weak self] in
            self?.dismissFlow()
        }

        vc.onGoButtonTap = { [weak self] in
            self?.showSoptletterWriting()
        }
        
        rootController?.pushViewController(vc, animated: true)
    }

    private func showSoptletterWriting() {
        var soptletterWriting = factory.makeSoptletterWritingVC(coordinator: self)

        soptletterWriting.vm.onNaviBackTap = { [weak self] in
            self?.currentNavigationController.popViewController(animated: true)
        }

        soptletterWriting.vm.onSubmitSuccess = { [weak self] in
            self?.currentNavigationController.popViewController(animated: true)
            ToastUtils.showMDSToast(type: .success, text: I18N.Soptletter.submitSuccess)
        }

        currentNavigationController.pushViewController(soptletterWriting.vc, animated: true)
    }

    private func dismissFlow() {
        rootController?.dismiss(animated: true) { [weak self] in
            self?.finishFlow?()
        }
    }
}
