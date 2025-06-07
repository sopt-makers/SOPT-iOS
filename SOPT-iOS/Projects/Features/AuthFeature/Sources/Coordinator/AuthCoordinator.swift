//
//  AuthCoordinator.swift
//  AuthFeatureTests
//
//  Created by Junho Lee on 2023/06/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import AuthFeatureInterface
import Core
import DSKit
import WebFeature

public protocol AuthCoordinatorFinishOutput {
    var finishFlow: ((UserType) -> Void)? { get set }
}

public typealias DefaultAuthCoordinator = BaseCoordinator & AuthCoordinatorFinishOutput

public final class AuthCoordinator: DefaultAuthCoordinator {

    public var finishFlow: ((UserType) -> Void)?

    private let factory: AuthFeatureViewBuildable
    private let router: LegacyRouter
    private var url: String?

    public init(
        router: LegacyRouter,
        factory: AuthFeatureViewBuildable,
        url: String? = nil
    ) {
        self.factory = factory
        self.router = router
        self.url = url
    }

    public override func start(by style: CoordinatorStartingOption) {
        var signIn = factory.makeSignIn()
        
        //TODO: 딥링크 URL 자동로그인 로직

        signIn.vm.onSignInSuccess = { [weak self]  in
            let userType = UserDefaultKeyList.Auth.getUserType()
            self?.finishFlow?(userType)
        }
        
        signIn.vm.onLoginHelpButtonTapped = { [weak self] in
            self?.showLoginHelpBottomSheet(on: signIn.vc)
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
            router.present(
                signIn.vc,
                animated: false,
                modalPresentationSytle: .fullScreen,
                modalTransitionStyle: .crossDissolve
            )
        case .root:
            router.replaceRootWindow(signIn.vc, withAnimation: false)
            router.hideTitles()
        case .rootWindow(let animated, let message):
            guard !animated else {
                router.replaceRootWindow(signIn.vc, withAnimation: true)
                router.hideTitles()
                return
            }

            guard let message else {
                router.replaceRootWindow(signIn.vc, withAnimation: true)
                router.hideTitles()
                return
            }

            router.replaceRootWindow(signIn.vc, withAnimation: true) { newWindow in
                Toast.show(
                    message: message,
                    view: newWindow
                )
            }
            router.hideTitles()
        case .push: break
        }
        
    }
}

extension AuthCoordinator {
    private func runUserNotFoundFlow() {
        var userNotFoundVC = self.factory.makeUserNotFound()
        userNotFoundVC.onLoginRetryButtonTapped = { [weak self] in
            self?.router.popToRootModule(animated: true)
        }
        
        userNotFoundVC.onLoginHelpButtonTapped = { [weak self] in
            self?.showLoginHelpBottomSheet(on: userNotFoundVC)
        }
        
        self.router.push(userNotFoundVC)
    }
    
    private func runSignUpFlow() {
        var signUpVC = self.factory.makeSignUp()
        
        signUpVC.vm.onLoginHelpButtonTapped = { [weak self] in
            guard let url = URL(string: ExternalURL.SOPT.memberVerifyGoogleForm) else { return }
            
            let webView = SOPTWebView(startWith: url)
            self?.router.asNavigationController.pushViewController(webView, animated: true)
        }
        
        self.router.push(signUpVC.vc)
    }
    
    private func runChangeSocialFlow() {
        var changeSocialAccount = self.factory.makeChangeSocialAccount()
        
        changeSocialAccount.vm.changeSocialAccountSucceed = { [weak self] in
            let userType = UserDefaultKeyList.Auth.getUserType() //TODO: 인증중앙화 후 로직으로 수정
            self?.finishFlow?(userType)
        }
        
        self.router.push(changeSocialAccount.vc)
    }
    
    private func runSearchSocialFlow() {
        var searchSocialAccount = self.factory.makeSearchSocialAccount()
        
        searchSocialAccount.vm.searchSocialAccountSucceed = { [weak self] _ in
            self?.router.popToRootModule(animated: true)
        }
        
        self.router.push(searchSocialAccount.vc)
    }
    
    private func showLoginHelpBottomSheet(on vc: LegacyViewControllable) {
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
        
        let bottomSheetManager = BottomSheetManager(
            configuration: .fixed(
                minHeight: bottomSheetVC.minimumContentHeight,
                prefersGrabberVisible: false)
        )
        
        self.router.showBottomSheet(
            manager: bottomSheetManager,
            toPresent: bottomSheetVC,
            on: vc.viewController
        )
    }
}


