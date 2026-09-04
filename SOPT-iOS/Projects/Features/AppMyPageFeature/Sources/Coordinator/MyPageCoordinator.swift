//
//  MyPageCoordinator.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/4/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import AppMyPageFeatureInterface
import WebFeature

public protocol MyPageCoordinatorDelegate: AnyObject {
    func myPageCoordinator(_ coordinator: MyPageCoordinator, to destination: MyPageCoordinatorDestination)
}

public final class MyPageCoordinator: BaseCoordinator {

    // MARK: - Properties

    public weak var delegate: MyPageCoordinatorDelegate?
    public var finishFlow: (() -> Void)?
    public var requestCoordinating: ((MyPageCoordinatorDestination) -> Void)?
    public var onShowSoptlog: (() -> Void)?

    private let factory: MyPageFeatureBuildable
    private let userType: UserType
    private weak var navigationController: UINavigationController?

    // MARK: - Init

    public init(
        factory: MyPageFeatureBuildable,
        userType: UserType,
        navigationController: UINavigationController
    ) {
        self.factory = factory
        self.userType = userType
        self.navigationController = navigationController
    }

    // MARK: - Coordinator Life Cycle

    public override func start() {
        showMyPage()
    }

    // MARK: - Navigation

    private func showMyPage() {
        var myPage = factory.makeAppMyPage(userType: userType, coordinator: self)

        myPage.vm.onNaviBackButtonTap = { [weak self] in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }

        myPage.vm.onShowLogout = { [weak self] in
            guard let self else { return }
            self.delegate?.myPageCoordinator(self, to: .signIn)
        }

        myPage.vm.onShowLogin = { [weak self] in
            guard let self else { return }
            self.delegate?.myPageCoordinator(self, to: .signIn)
        }

        myPage.vm.onLogoutTap = { confirmed in
            AlertUtils.presentAlertVC(
                type: .default(primary: .init(I18N.MyPage.logoutDialogGrantButtonTitle)),
                title: I18N.MyPage.logoutDialogTitle,
                description: I18N.MyPage.logoutDialogDescription,
                customAction: confirmed
            )
        }

        myPage.vm.onResetSoptampTap = { confirmed in
            AlertUtils.presentAlertVC(
                type: .danger(primary: .init(I18N.MyPage.reset)),
                title: I18N.MyPage.resetMissionTitle,
                description: I18N.MyPage.resetMissionDescription,
                customAction: confirmed
            )
        }

        myPage.vm.onEditProfileTap = { [weak self] in
            guard let self, let url = URL(string: ExternalURL.Playground.editProfile) else { return }
            let webView = SOPTWebView(startWith: url)
            self.navigationController?.pushViewController(webView, animated: true)
        }

        myPage.vm.onShowSoptlog = { [weak self] in
            self?.onShowSoptlog?()
        }

        myPage.vm.onPolicyItemTap = { [weak self] in
            guard let self, let url = URL(string: ExternalURL.Notion.privacyPolicy) else { return }
            let webView = SOPTWebView(startWith: url)
            self.navigationController?.pushViewController(webView, animated: true)
        }

        myPage.vm.onTermsOfUseItemTap = { [weak self] in
            guard let self, let url = URL(string: ExternalURL.Notion.termsOfUse) else { return }
            let webView = SOPTWebView(startWith: url)
            self.navigationController?.pushViewController(webView, animated: true)
        }

        myPage.vm.onEditOnelineSentenceItemTap = { [weak self] in
            guard let self else { return }
            let sentenceEditVC = self.factory.makeSentenceEditVC()
            self.navigationController?.pushViewController(sentenceEditVC, animated: true)
        }

        myPage.vm.onWithdrawalItemTap = { [weak self] userType in
            self?.showWithdrawal(userType: userType)
        }

        myPage.vm.onAlertButtonTap = { [weak self] url in
            self?.showAlertSetting(url: url)
        }

        navigationController?.setViewControllers([myPage.vc], animated: false)
    }
    
    private func showWithdrawWebView(_ formUrl: String) {
        guard let url = URL(string: formUrl) else { return }
        
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first?.rootViewController else { return }
        
        rootViewController.present(SOPTWebView(startWith: url), animated: true)
    }

    private func showWithdrawal(userType: UserType) {
        var withdrawal = factory.makeWithdrawalVC(userType: userType)
        withdrawal.vc.hidesBottomBarWhenPushed = true
        
        withdrawal.vm.onWithdrawal = { [weak self] formUrl in
            guard let self else { return }
            self.delegate?.myPageCoordinator(self, to: .signIn)
            self.showWithdrawWebView(formUrl)
        }
        
        withdrawal.vm.onWithdrawalConfirm = { completion  in
            AlertUtils.presentAlertVC(
                type: .danger(primary: .init(I18N.MyPage.EtcSection.withdrawal)),
                title: I18N.MyPage.withdrawalDialogTitle,
                description: I18N.MyPage.withdrawalDialogDescription,
                customAction: completion
            )
        }
        
        self.navigationController?.pushViewController(withdrawal.vc, animated: true)
    }

    private func showAlertSetting(url: String) {
        openExternalLink(urlStr: url)
    }
}
