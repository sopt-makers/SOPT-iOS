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
    
    // 임시
    private let onboardingFinished: Bool = false

    public var finishFlow: (() -> Void)?

    private let factory: SoptletterFeatureBuildable
    private weak var navigationController: UINavigationController?
    private weak var soptletterRootController: UINavigationController?

    // MARK: - Init

    public init(
        navigationController: UINavigationController,
        factory: SoptletterFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }

    // MARK: - Coordinator Life Cycle

    public override func start() {
        if onboardingFinished {
            // main routing
        } else {
            showSoptletterOnboarding()
        }
    }

    // MARK: - Navigation
    private func showSoptletterOnboarding() {
        let soptletterOnboarding = factory.makeSoptletterOnboardingVC(coordinator: self)
        
        soptletterOnboarding.vm.onStartButtonTap = { [weak self] in
            self?.showSoptletterCheckNickname()
        }
        
        soptletterOnboarding.vm.onNaviBackTap = { [weak self] in
            self?.soptletterRootController?.dismiss(animated: true)
        }
        
        let navController = UINavigationController(rootViewController: soptletterOnboarding.vc)
        navController.modalPresentationStyle = .fullScreen
        navController.setNavigationBarHidden(true, animated: false)
        soptletterRootController = navController
        navigationController?.present(navController, animated: true)
    }
    
    private func showSoptletterCheckNickname() {
        let checkNickname = factory.makeSoptletterNicknameCheckVC(coordinator: self)
        
        checkNickname.vm.onNaviBackTap = { [weak self] in
            self?.soptletterRootController?.dismiss(animated: true)
        }
        
        checkNickname.vm.onGoButtonTap = { [weak self] in
            self?.showSoptletterWriting()
        }
        
        soptletterRootController?.pushViewController(checkNickname.vc, animated: true)
    }

    private func showSoptletterWriting() {
        var soptletterWriting = factory.makeSoptletterWritingVC(coordinator: self)

        soptletterWriting.vm.onNaviBackTap = { [weak self] in
            self?.soptletterRootController?.popViewController(animated: true)
        }

        soptletterWriting.vm.onSubmitSuccess = { [weak self] in
            self?.soptletterRootController?.popViewController(animated: true)
            ToastUtils.showMDSToast(type: .success, text: I18N.Soptletter.submitSuccess)
        }

        soptletterRootController?.pushViewController(soptletterWriting.vc, animated: true)
    }
}
