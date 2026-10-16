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
    private weak var soptletterMainController: UINavigationController?

    // MARK: - Init

    public init(
        navigationController: UINavigationController,
        factory: SoptletterFeatureBuildable
    ) {
        self.navigationController = navigationController
        self.factory = factory
        super.init()
    }

    // MARK: - Coordinator Life Cycle

    public override func start() {
        if UserDefaultKeyList.User.isCompleteSoptletterOnboarding == true {
            showSelectTopicMain(isRoot: true)
        } else {
            showSoptletterOnboarding()
        }
    }
    
    public func startWithMessageDetail(topicId: Int, messageId: Int) {
        showSoptletterMain(topicId: topicId, messageId: messageId)
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
            self?.showSelectTopicMain(isRoot: true)
        }
        
        checkNickname.vm.showAlert = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        soptletterRootController?.pushViewController(checkNickname.vc, animated: true)
    }
    
    private func showSelectTopicMain(isRoot: Bool) {
        var selectTopic = factory.makeSelectTopicVC(coordinator: self)
        
        selectTopic.vm.onNaviBackTap = { [weak self] in
            if isRoot {
                self?.soptletterRootController?.dismiss(animated: true)
            } else {
                self?.soptletterRootController?.popViewController(animated: true)
            }
        }
        
        selectTopic.vm.onCellTap = { [weak self] topic in
            self?.showSoptletterMain(topicId: topic.topicId) {
                selectTopic.vm.refreshTopicTrigger()
            }
        }
        
        selectTopic.vm.onWriteButtonTap = { [weak self] in
            self?.showSoptletterWriting(on: self?.soptletterRootController)
        }
        
        selectTopic.vm.showAlert = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        if let soptletterRootController {
            soptletterRootController.pushViewController(selectTopic.vc, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: selectTopic.vc)
            navController.modalPresentationStyle = .fullScreen
            navController.setNavigationBarHidden(true, animated: false)
            soptletterRootController = navController
            navigationController?.present(navController, animated: true)
        }
    }

    private func showSoptletterWriting(
        on controller: UINavigationController?,
        onSubmitSuccess: (() -> Void)? = nil
    ) {
        let soptletterWriting = factory.makeSoptletterWritingVC(coordinator: self)
        
        soptletterWriting.vm.onNaviBackTap = { [weak controller] in
            controller?.popViewController(animated: true)
        }

        soptletterWriting.vm.onSubmitSuccess = { [weak controller] in
            onSubmitSuccess?()
            controller?.popViewController(animated: true)
            ToastUtils.showMDSToast(type: .success, text: I18N.Soptletter.submitSuccess)
        }
        
        soptletterWriting.vm.onSelectTopicTap = { [weak self, weak controller, weak viewModel = soptletterWriting.vm] in
            self?.showSelectTopicBottomSheet(
                on: controller,
                selectedTopicId: viewModel?.selectedTopicId
            ) { topic in
                viewModel?.selectTopic(topic)
            }
        }

        controller?.pushViewController(soptletterWriting.vc, animated: true)
    }
    
    private func showSelectTopicBottomSheet(
        on controller: UIViewController?,
        selectedTopicId: Int?,
        onConfirm: @escaping (SoptletterTopicModel) -> Void
    ) {
        let selectTopicBottomSheet = factory.makeSelectTopicBottomSheet(coordinator: self)
        selectTopicBottomSheet.vc.modalPresentationStyle = .overFullScreen
        selectTopicBottomSheet.vc.modalTransitionStyle = .crossDissolve
        
        selectTopicBottomSheet.vm.selectedTopicId = selectedTopicId
        
        selectTopicBottomSheet.vm.onNaviBackTap = { [weak controller] in
            controller?.dismiss(animated: true)
        }
        
        selectTopicBottomSheet.vm.showAlert = {
            AlertUtils.presentNetworkAlertVC()
        }
        
        selectTopicBottomSheet.vm.onConFirmButtonTap = { [weak controller] topic in
            onConfirm(topic)
            controller?.dismiss(animated: true)
        }
        
        controller?.present(selectTopicBottomSheet.vc, animated: true)
    }
    
    private func showSoptletterMain(
        topicId: Int?, messageId: Int? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        var soptletterMain = factory.makeSoptletterMainVC(coordinator: self, topicId: topicId)

        soptletterMain.vm.onNaviBackTap = { [weak self] in
            self?.soptletterMainController?.dismiss(animated: true) {
                onDismiss?()
            }
        }
        
        soptletterMain.vm.onWriteTap = { [weak self] in
            self?.showSoptletterWriting(on: self?.soptletterMainController) {
                soptletterMain.vm.refreshMessagesTrigger()
            }
        }

        soptletterMain.vm.onReportTap = { [weak self] url in
            let webView = SOPTWebView(startWith: url)
            self?.soptletterMainController?.pushViewController(webView, animated: true)
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
                
        let navController = UINavigationController(rootViewController: soptletterMain.vc)
        navController.modalPresentationStyle = .fullScreen
        navController.setNavigationBarHidden(true, animated: false)
        soptletterMainController = navController
        
        let deeplinkController = soptletterRootController ?? navigationController
        deeplinkController?.present(navController, animated: true) { [weak self] in
        guard let self, let messageId, let topicId else { return }
            self.presentSoptletterDetail(messageId, topicId, refreshTarget: soptletterMain)
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
                self.soptletterMainController?.popViewController(animated: true)
            }
            
            self.soptletterMainController?.present(activityVC, animated: true)
        }
        
        soptletterPrint.vm.onNaviBackTap = { [weak self] in
            self?.soptletterMainController?.popViewController(animated: true)
        }
        
        soptletterMainController?.pushViewController(soptletterPrint.vc, animated: true)
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
        
        soptletterMainController?.present(soptletterDetail.vc, animated: true)
    }
}
