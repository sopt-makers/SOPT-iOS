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

    // MARK: - Coordinator Life Cycle

    public override func start() {
        showSoptletterMain()
    }

    // MARK: - Navigation

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
    
    private func showSoptletterMain() {
        var soptletterMain = factory.makeSoptletterMainVC(coordinator: self)
        
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
        
        navigationController?.present(soptletterDetail.vc, animated: true)
    }
    
    private func showSelectTopic() {
        var vc = factory.makeSelectTopicVC(coordinator: self)
        
        vc.onNaviBackTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        vc.onCellTap = { [weak self] title in
            // 임시
            self?.showSoptletter(title: title)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showSoptletter(title: String) { }
}
