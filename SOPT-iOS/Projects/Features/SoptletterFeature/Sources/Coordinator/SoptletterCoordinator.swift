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
import Domain

public final class SoptletterCoordinator: BaseCoordinator {

    // MARK: - Properties

    public var finishFlow: (() -> Void)?

    private let factory: SoptletterFeatureBuildable
    private var soptletterMain: SoptletterMainPresentable!
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
        showSoptletterOnboarding()
//        if UserDefaultKeyList.User.isCompleteSoptletterOnboarding == true {
//            showSoptletterMain()
//        } else {
//            showSoptletterOnboarding()
//        }
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
            // 임시
            self?.showSelectTopic()
        }
        
        checkNickname.vm.showAlert = {
            AlertUtils.presentNetworkAlertVC()
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
    
    private func showSoptletterMain() {
        soptletterMain = factory.makeSoptletterMainVC(coordinator: self)
        
        soptletterMain.vm.onNaviBackTap = { [weak self] in
            print("handle soptletterMain.vm.onNaviBackTap")
        }
        
        soptletterMain.vm.onWriteTap = { [weak self] in
            print("handle soptletterMain.vm.onWriteTap")
        }
        
        soptletterMain.vm.onReportTap = { [weak self] in
            print("handle soptletterMain.vm.onReportTap")
        }
        
        soptletterMain.vm.onPostItTap = { [weak self] in
            print("handle soptletterMain.vm.onPostItTap")
        }
        
        soptletterMain.vm.onDownloadTap = { [weak self] in
            print("handle soptletterMain.vm.onDownloadTap")
        }
        
        soptletterMain.vm.onCellTap = { [weak self] messageId, topicId in
            self?.presentSoptletterDetail(messageId, topicId)
        }
        
        soptletterMain.vm.onError = { [weak self] in
            AlertUtils.presentNetworkAlertVC()
        }
        
        navigationController?.pushViewController(soptletterMain.vc, animated: true)
    }
    
    private func presentSoptletterDetail(_ messageId: Int, _ topicId: Int) {
        var soptletterDetail = factory.makeSoptletterDetailVC(coordinator: self, messageId: messageId, topicId: topicId)
        
        soptletterDetail.vm.onNaviBackTap = { [weak self] in
            print("handle soptletterMain.vm.onNaviBackTap")
        }
        
        soptletterDetail.vm.onError = { [weak self] in
            AlertUtils.presentNetworkAlertVC()
        }
        
        soptletterDetail.vm.onEditCompleted = { [weak self] in
            self?.soptletterMain.vm.refreshMessagesTrigger()
        }
        
        soptletterDetail.vm.onDeleteCompleted = { [weak self] in
            self?.soptletterMain.vm.refreshMessagesTrigger()
        }
        
        navigationController?.present(soptletterDetail.vc, animated: true)
    }
    
    private func showSelectTopic() {
        var selectTopic = factory.makeSelectTopicVC(coordinator: self)
        
        selectTopic.vm.onNaviBackTap = { [weak self] in
            self?.soptletterRootController?.popViewController(animated: true)
        }
        
        selectTopic.vm.onCellTap = { [weak self] title in
            self?.showSoptletterMain()
        }
        
        selectTopic.vm.showAlert = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        soptletterRootController?.pushViewController(selectTopic.vc, animated: true)
    }
}
