//
//  AuthCoordinator.swift
//  AuthFeatureTests
//
//  Created by Junho Lee on 2023/06/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import UIKit
import BaseFeatureDependency
import AuthFeatureInterface
import Core
import DSKit
import WebFeature

public protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinator(_ coordinator: AuthCoordinator, userType: UserType)
}

public final class AuthCoordinator: DefaultAuthCoordinator {
    // TODO: DefaultAuthCoordinator가 BaseCoordinator만 채택하도록 변경
    public var finishFlow: ((UserType) -> Void)?

    private let factory: AuthFeatureViewBuildable
    private weak var navigationController: UINavigationController?
    private var url: String?
    public weak var delegate: AuthCoordinatorDelegate?

    public init(
        navigationController: UINavigationController,
        factory: AuthFeatureViewBuildable,
        url: String? = nil
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.url = url
    }

    public override func start(by style: CoordinatorStartingOption) {
        var signIn = factory.makeSignIn(coordinator: self)
        
        //TODO: 딥링크 URL 자동로그인 로직

        signIn.vm.onSignInSuccess = { [weak self]  in
            guard let self else { return }
            let userType = UserDefaultKeyList.Auth.getUserType()
            self.delegate?.authCoordinator(self, userType: userType)
        }
        
        signIn.vm.onLoginHelpButtonTapped = { [weak self, weak viewController = signIn.vc] in
            guard let viewController else { return }
            self?.showLoginHelpBottomSheet(on: viewController)
        }
        
        signIn.vm.onVisitorButtonTapped = { [weak self] in
            guard let self else { return }
            self.delegate?.authCoordinator(self, userType: .visitor)
        }
        
        signIn.vm.onSocialLoginFail = { [weak self] in
            self?.runUserNotFoundFlow()
        }
        
        signIn.vm.onSignUpButtonTapped = { [weak self] in
            self?.runSignUpFlow()
        }
        
        guard let navigationController = self.navigationController else { return }
        
        switch style {
        case .modal:
            signIn.vc.modalPresentationStyle = .fullScreen
            signIn.vc.modalTransitionStyle = .crossDissolve
            navigationController.present(signIn.vc, animated: false)
        case .root:
            navigationController.isNavigationBarHidden = true
            navigationController.setViewControllers([signIn.vc], animated: false)
            ViewControllerUtils.setRootNavigationController(window: UIWindow.keyWindowGetter!,
                                                            navigationController: navigationController,
                                                            withAnimation: false)
        case .rootWindow(let animated, let message):
            navigationController.isNavigationBarHidden = true
            navigationController.setViewControllers([signIn.vc], animated: false)
            
            guard !animated else {
                ViewControllerUtils.setRootNavigationController(window: UIWindow.keyWindowGetter!,
                                                                navigationController: navigationController,
                                                                withAnimation: true)
                return
            }

            guard let message else {
                ViewControllerUtils.setRootNavigationController(window: UIWindow.keyWindowGetter!,
                                                          navigationController: navigationController,
                                                          withAnimation: true)
                return
            }

            ViewControllerUtils.setRootNavigationController(window: UIWindow.keyWindowGetter!,
                                                      navigationController: navigationController,
                                                      withAnimation: true) { newWindow in
                Toast.show(
                    message: message,
                    view: newWindow
                )
            }
        case .push: break
        }
    }
}

extension AuthCoordinator {
    private func runUserNotFoundFlow() {
        let userNotFoundVC = self.factory.makeUserNotFound()
        userNotFoundVC.onLoginRetryButtonTapped = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        userNotFoundVC.onLoginHelpButtonTapped = { [weak self, weak viewController = userNotFoundVC.viewController] in
            guard let viewController else { return }
            self?.showLoginHelpBottomSheet(on: viewController)
        }
        
        self.navigationController?.pushViewController(userNotFoundVC.viewController, animated: true)
    }
    
    private func runSignUpFlow() {
        var signUpVC = self.factory.makeSignUp()
        
        signUpVC.vm.onSignUpSuccess = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        signUpVC.vm.onLoginHelpButtonTapped = { [weak self] in
            guard let url = URL(string: ExternalURL.SOPT.memberVerifyGoogleForm) else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.navigationController?.pushViewController(webView, animated: true)
        }
        
        self.navigationController?.pushViewController(signUpVC.vc, animated: true)
    }
    
    private func runChangeSocialFlow() {
        var changeSocialAccount = self.factory.makeChangeSocialAccount()
        
        changeSocialAccount.vm.changeSocialAccountSucceed = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        self.navigationController?.pushViewController(changeSocialAccount.vc, animated: true)
    }
    
    private func runSearchSocialFlow() {
        var searchSocialAccount = self.factory.makeSearchSocialAccount()
        
        searchSocialAccount.vm.searchSocialAccountSucceed = { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        self.navigationController?.pushViewController(searchSocialAccount.vc, animated: true)
    }
    
    private func showLoginHelpBottomSheet(on vc: UIViewController) {
        guard let bottomSheetVC = self.factory.makeLoginHelpBottomSheet().viewController as? LoginHelpBottomSheetVC
        else { return Void() }
        
        bottomSheetVC.onResetSocialAccountButtonDidTap = { [weak self, weak bottomSheetVC] in
            bottomSheetVC?.dismiss(animated: true)
            self?.runChangeSocialFlow()
        }
        
        bottomSheetVC.onWantToKnowLoginAccountButtonDidTap = { [weak self, weak bottomSheetVC] in
            bottomSheetVC?.dismiss(animated: true)
            self?.runSearchSocialFlow()
        }
        
        bottomSheetVC.onInquireToKakaoTalkButtonDidTap = { [weak bottomSheetVC] in
            bottomSheetVC?.dismiss(animated: true)
            openExternalLink(urlStr: ExternalURL.KakaoTalk.serviceProposal)
        }
        
        let bottomSheetManager = BottomSheetManager(
            configuration: .fixed(
                minHeight: bottomSheetVC.minimumContentHeight,
                prefersGrabberVisible: false)
        )
        
        bottomSheetManager.present(toPresent: bottomSheetVC, on: vc)
    }
}


