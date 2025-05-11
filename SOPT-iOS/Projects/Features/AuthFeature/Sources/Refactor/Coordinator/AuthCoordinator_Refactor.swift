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

public final class AuthCoordinator_Refactor: DefaultAuthCoordinator {


    public var finishFlow: ((UserType) -> Void)?

    private let factory: AuthFeatureViewBuildable_Refactor
    private let router: LegacyRouter
    private var url: String?

    public init(
        router: LegacyRouter,
        factory: AuthFeatureViewBuildable_Refactor,
        url: String? = nil
    ) {
        self.factory = factory
        self.router = router
        self.url = url
    }

    public override func start(by style: CoordinatorStartingOption) {
        var signIn = factory.makeSignIn()

        signIn.vm.onSignInSuccess = { [weak self] type in
            switch type {
            case .loginSuccess:
                let userType = UserDefaultKeyList.Auth.getUserType()
                self?.finishFlow?(userType)
            case .loginFailure: break
            }
        }

        signIn.vm.onSignInSuccess = { [weak self] type in
            switch type {
            case .loginSuccess:
                let userType = UserDefaultKeyList.Auth.getUserType()
                self?.finishFlow?(userType)
            case .loginFailure: break
            }
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

extension AuthCoordinator_Refactor {
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
            self?.showLoginHelpBottomSheet(on: signUpVC.vc)
        }
        
        self.router.push(signUpVC.vc)
    }

    private func showLoginHelpBottomSheet(on vc: LegacyViewControllable) {
        guard let bottomSheetVC = self.factory.makeLoginHelpBottomSheet().viewController as? LoginHelpBottomSheetVC
        else { return Void() }
        
        bottomSheetVC.onResetSocialAccountButtonDidTap = {
            print("resetSocialAccountButtonDidTap") //TODO: asdf
        }
        
        bottomSheetVC.onWantToKnowLoginAccountButtonDidTap = {
            print("wantToKnowLoginAccountButtonDidTap") //TODO: asdf

        }
        
        let bottomSheetManager = BottomSheetManager(configuration: .fixed(minHeight: bottomSheetVC.minimumContentHeight,
                                                                          prefersGrabberVisible: false))
        
        self.router.showBottomSheet(
            manager: bottomSheetManager,
            toPresent: bottomSheetVC,
            on: vc.viewController
        )
    }
}


