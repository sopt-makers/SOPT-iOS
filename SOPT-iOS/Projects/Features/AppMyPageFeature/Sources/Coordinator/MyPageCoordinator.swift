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
                type: .titleDescription,
                theme: .main,
                title: I18N.MyPage.logoutDialogTitle,
                description: I18N.MyPage.logoutDialogDescription,
                customButtonTitle: I18N.MyPage.logoutDialogGrantButtonTitle,
                customAction: confirmed,
                animated: true
            )
        }

        myPage.vm.onResetSoptampTap = { confirmed in
            AlertUtils.presentAlertVC(
                type: .titleDescription,
                theme: .main,
                title: I18N.MyPage.resetMissionTitle,
                description: I18N.MyPage.resetMissionDescription,
                customButtonTitle: I18N.MyPage.reset,
                customAction: confirmed,
                animated: true
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

    private func showWithdrawal(userType: UserType) {
        var withdrawal = factory.makeWithdrawalVC(userType: userType)
        
        withdrawal.vc.hidesBottomBarWhenPushed = true
        
        withdrawal.vm.onWithdrawal = { [weak self] in
            guard let self else { return }
            self.delegate?.myPageCoordinator(self, to: .signInWithToast)
        }
        
        self.navigationController?.pushViewController(withdrawal.vc, animated: true)
    }

    private func showAlertSetting(url: String) {
        openExternalLink(urlStr: url)
    }
}
