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

public final class SoptletterCoordinator: BaseCoordinator {

    // MARK: - Properties

    public var finishFlow: (() -> Void)?

    private let factory: SoptletterFeatureBuildable
    private weak var navigationController: UINavigationController?

    // MARK: - Init

    public init(
        navigationController: UINavigationController,
        factory: SoptletterFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
//    private var currentNavigationController: UINavigationController {
//        rootController ?? navigationController
//    }

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
        let navigationController = UINavigationController(rootViewController: soptletterOnboarding.vc)
        navigationController.setNavigationBarHidden(true, animated: false)

        soptletterOnboarding.vm.onStartButtonTap = { [weak self] in
            self?.showSoptletterCheckNickname(on: navigationController)
        }
        
        soptletterOnboarding.vm.onNaviBackTap = { [weak self] in
            self?.dismissFlow()
        }

        self.navigationController?.present(navigationController, animated: true)
    }
    
    private func showSoptletterCheckNickname(on nav: UINavigationController) {
        let checkNickname = factory.makeSoptletterNicknameCheckVC(coordinator: self)
        
        checkNickname.vm.onNaviBackTap = { [weak self] in
            self?.dismissFlow()
        }
        
        checkNickname.vm.onGoButtonTap = { [weak self] in
            self?.showSoptletterWriting()
        }
        
        nav.pushViewController(checkNickname.vc, animated: true)
    }

    private func showSoptletterWriting() {
        var soptletterWriting = factory.makeSoptletterWritingVC(coordinator: self)

        soptletterWriting.vm.onNaviBackTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        soptletterWriting.vm.onSubmitSuccess = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            ToastUtils.showMDSToast(type: .success, text: I18N.Soptletter.submitSuccess)
        }

        navigationController?.pushViewController(soptletterWriting.vc, animated: true)
    }

    private func dismissFlow() {
        navigationController?.dismiss(animated: true) { [weak self] in
            self?.finishFlow?()
        }
    }
}
