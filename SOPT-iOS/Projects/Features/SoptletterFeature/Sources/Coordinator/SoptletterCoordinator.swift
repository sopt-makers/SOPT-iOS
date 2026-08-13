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
import WebFeature

public final class SoptletterCoordinator: BaseCoordinator {

    // MARK: - Properties

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
        if UserDefaultKeyList.User.isCompleteSoptletterOnboarding == true {
            showSoptletterMain(topicId: nil, isRoot: true)
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
        
        checkNickname.vm.onGoButtonTap = { [weak self]  in
            self?.showSelectTopic()
        }
        
        checkNickname.vm.showAlert = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        soptletterRootController?.pushViewController(checkNickname.vc, animated: true)
    }

    private func showSoptletterWriting(refreshTarget: SoptletterMainPresentable) {
        var soptletterWriting = factory.makeSoptletterWritingVC(coordinator: self)

        soptletterWriting.vm.onNaviBackTap = { [weak self] in
            self?.soptletterRootController?.popViewController(animated: true)
        }

        soptletterWriting.vm.onSubmitSuccess = { [weak self] in
            refreshTarget.vm.refreshMessagesTrigger()
            self?.soptletterRootController?.popViewController(animated: true)
            ToastUtils.showMDSToast(type: .success, text: I18N.Soptletter.submitSuccess)
        }

        soptletterRootController?.pushViewController(soptletterWriting.vc, animated: true)
    }
    
    private func showSoptletterMain(topicId: Int?, isRoot: Bool) {
        var soptletterMain = factory.makeSoptletterMainVC(coordinator: self, topicId: topicId, isRoot: isRoot)        
        
        soptletterMain.vm.onNaviBackTap = { [weak self] in
            if isRoot {
                self?.soptletterRootController?.dismiss(animated: true)
            } else {
                self?.soptletterRootController?.popViewController(animated: true)
            }
        }
        
        soptletterMain.vm.onWriteTap = { [weak self] in
            self?.showSoptletterWriting(refreshTarget: soptletterMain)
        }
        
        soptletterMain.vm.onMenuTap = { [weak self] in
            self?.showSelectTopic()
        }
        
        soptletterMain.vm.onReportTap = { [weak self] url in
            let webView = SOPTWebView(startWith: url)
            self?.soptletterRootController?.pushViewController(webView, animated: true)
        }
        
        soptletterMain.vm.onDownloadTap = { [weak self] image, pdfURL in
            self?.showSoptletterPrint(image, pdfURL)
        }
        
        soptletterMain.vm.onCellTap = { [weak self] messageId, topicId in
            self?.presentSoptletterDetail(messageId, topicId, refreshTarget: soptletterMain)
        }
        
        soptletterMain.vm.onError = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        // CTA 클릭 시에도 새 인스턴스를 push (isRoot: false)
        soptletterMain.vm.ctaTap = { [weak self] newTopicId in
            self?.showSoptletterMain(topicId: newTopicId, isRoot: false)
        }
        
        if let soptletterRootController {
            soptletterRootController.pushViewController(soptletterMain.vc, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: soptletterMain.vc)
            navController.modalPresentationStyle = .fullScreen
            navController.setNavigationBarHidden(true, animated: false)
            self.soptletterRootController = navController
            navigationController?.present(navController, animated: true)
        }
    }
    
    private func showSoptletterPrint(_ uiImage: UIImage, _ pdfURL: URL) {
        var soptletterPrint = factory.makeSoptletterPrintVC(coordinator: self, uiImage: uiImage, pdfURL: pdfURL)

        soptletterPrint.vm.onPDFSaveTap = { [weak self] pdfURL in
            guard let self else { return }
            let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)

            activityVC.completionWithItemsHandler = { [weak self] activityType, completed, returnedItems, error in
                guard let self else { return }

                if error != nil {
                    ToastUtils.showMDSToast(type: .error, text: I18N.Soptletter.Print.saveFailure)
                    return
                }

                guard completed else { return }

                ToastUtils.showMDSToast(type: .success, text: I18N.Soptletter.Print.saveSuccess)
                self.soptletterRootController?.popViewController(animated: true)
            }
            
            self.soptletterRootController?.present(activityVC, animated: true)
        }
        
        soptletterPrint.vm.onNaviBackTap = { [weak self] in
            self?.soptletterRootController?.popViewController(animated: true)
        }
        
        soptletterRootController?.pushViewController(soptletterPrint.vc, animated: true)
    }
    
    private func presentSoptletterDetail(_ messageId: Int, _ topicId: Int, refreshTarget: SoptletterMainPresentable) {
        var soptletterDetail = factory.makeSoptletterDetailVC(coordinator: self, messageId: messageId, topicId: topicId)
        
        soptletterDetail.vm.onError = {
            AlertUtils.presentNetworkAlertVC()
        }

        soptletterDetail.vm.onEditCompleted = {
            refreshTarget.vm.refreshMessagesTrigger()
        }

        soptletterDetail.vm.onDeleteCompleted = {
            refreshTarget.vm.refreshMessagesTrigger()
        }
        
        soptletterRootController?.present(soptletterDetail.vc, animated: true)
    }
    
    private func showSelectTopic() {
        var selectTopic = factory.makeSelectTopicVC(coordinator: self)
        
        selectTopic.vm.onNaviBackTap = { [weak self] in
            self?.soptletterRootController?.popViewController(animated: true)
        }
        
        selectTopic.vm.onCellTap = { [weak self] topic in
            self?.showSoptletterMain(topicId: topic.topicId, isRoot: false)
        }
        
        selectTopic.vm.showAlert = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        soptletterRootController?.pushViewController(selectTopic.vc, animated: true)
    }
}
