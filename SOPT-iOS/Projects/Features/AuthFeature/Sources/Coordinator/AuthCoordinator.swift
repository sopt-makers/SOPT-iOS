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

public final class AuthCoordinator: DefaultAuthCoordinator {

    public var finishFlow: ((UserType) -> Void)?

    private let factory: AuthFeatureViewBuildable
    private let navigationController: UINavigationController
    private var url: String?

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
            let userType = UserDefaultKeyList.Auth.getUserType()
            self?.finishFlow?(userType)
        }
        
        signIn.vm.onLoginHelpButtonTapped = { [weak self, weak viewController = signIn.vc] in
            guard let viewController else { return }
            self?.showLoginHelpBottomSheet(on: viewController)
        }
        
        signIn.vm.onVisitorButtonTapped = { [weak self] in
            self?.finishFlow?(.visitor)
        }
        
        signIn.vm.onSocialLoginFail = { [weak self] in
            self?.runUserNotFoundFlow()
        }
        
        signIn.vm.onSignUpButtonTapped = { [weak self] in
            self?.runSignUpFlow()
        }
        
        switch style {
        case .modal:
            signIn.vc.modalPresentationStyle = .fullScreen
            signIn.vc.modalTransitionStyle = .crossDissolve
            navigationController.present(signIn.vc, animated: false)
        case .root:
            self.navigationController.isNavigationBarHidden = true
            self.navigationController.setViewControllers([signIn.vc], animated: false)
            ViewControllerUtils.setRootNavigationController(window: UIWindow.keyWindowGetter!,
                                                            navigationController: self.navigationController,
                                                            withAnimation: false)
        case .rootWindow(let animated, let message):
            self.navigationController.isNavigationBarHidden = true
            self.navigationController.setViewControllers([signIn.vc], animated: false)
            
            guard !animated else {
                ViewControllerUtils.setRootNavigationController(window: UIWindow.keyWindowGetter!,
                                                                navigationController: self.navigationController,
                                                                withAnimation: true)
                return
            }

            guard let message else {
                ViewControllerUtils.setRootNavigationController(window: UIWindow.keyWindowGetter!,
                                                          navigationController: self.navigationController,
                                                          withAnimation: true)
                return
            }

            ViewControllerUtils.setRootNavigationController(window: UIWindow.keyWindowGetter!,
                                                      navigationController: self.navigationController,
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
            self?.navigationController.popToRootViewController(animated: true)
        }
        
        userNotFoundVC.onLoginHelpButtonTapped = { [weak self, weak viewController = userNotFoundVC.viewController] in
            guard let viewController else { return }
            self?.showLoginHelpBottomSheet(on: viewController)
        }
        
        self.navigationController.pushViewController(userNotFoundVC.viewController, animated: true)
    }
    
    private func runSignUpFlow() {
        var signUpVC = self.factory.makeSignUp()
        
        signUpVC.vm.onSignUpSuccess = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }
        
        signUpVC.vm.onLoginHelpButtonTapped = { [weak self] in
            guard let url = URL(string: ExternalURL.SOPT.memberVerifyGoogleForm) else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.navigationController.pushViewController(webView, animated: true)
        }
        
        self.navigationController.pushViewController(signUpVC.vc, animated: true)
    }
    
    private func runChangeSocialFlow() {
        var changeSocialAccount = self.factory.makeChangeSocialAccount()
        
        changeSocialAccount.vm.changeSocialAccountSucceed = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }
        
        self.navigationController.pushViewController(changeSocialAccount.vc, animated: true)
    }
    
    private func runSearchSocialFlow() {
        var searchSocialAccount = self.factory.makeSearchSocialAccount()
        
        searchSocialAccount.vm.searchSocialAccountSucceed = { [weak self] _ in
            self?.navigationController.popToRootViewController(animated: true)
        }
        
        self.navigationController.pushViewController(searchSocialAccount.vc, animated: true)
    }
    
    private func showLoginHelpBottomSheet(on vc: UIViewController) {
        guard let bottomSheetVC = self.factory.makeLoginHelpBottomSheet().viewController as? LoginHelpBottomSheetVC
        else { return Void() }
        
        bottomSheetVC.onResetSocialAccountButtonDidTap = { [weak self] in
            bottomSheetVC.dismiss(animated: true)
            self?.runChangeSocialFlow()
        }
        
        bottomSheetVC.onWantToKnowLoginAccountButtonDidTap = { [weak self] in
            bottomSheetVC.dismiss(animated: true)
            self?.runSearchSocialFlow()
        }
        
        bottomSheetVC.onInquireToKakaoTalkButtonDidTap = { 
            bottomSheetVC.dismiss(animated: true)
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


