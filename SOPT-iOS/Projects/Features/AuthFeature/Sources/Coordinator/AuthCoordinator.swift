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

public protocol AuthCoordinatorFinishOutput {
    var finishFlow: ((UserType) -> Void)? { get set }
}

public typealias DefaultAuthCoordinator = BaseCoordinator & AuthCoordinatorFinishOutput

public final class AuthCoordinator: DefaultAuthCoordinator {
    
    public var finishFlow: ((UserType) -> Void)?
    
    private let factory: AuthFeatureViewBuildable
    private let router: Router
    private var url: String?
    
    public init(router: Router, factory: AuthFeatureViewBuildable, url: String? = nil) {
        self.factory = factory
        self.router = router
        self.url = url
    }
    
    public override func start(by style: CoordinatorStartingOption) {
        var signIn = factory.makeSignIn()
        
        if let url { redirectSignIn(module: &signIn.vc, url: url) }
        
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
        self.router.push(signUpVC.vc)
    }
    
    private func showLoginHelpBottomSheet(on vc: ViewControllable) {
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


//AS IS: 2024.10.26 이전. 플그 로그인 로직
extension AuthCoordinator {
    func parseParameter(url: String) -> [(query: String, value: String)] {
        let components = URLComponents(string: url)
        let params = components?.query ?? ""
        guard params.count > 0 && params != "",
              let items = components?.queryItems else {
            return []
        }
        return items.map {
            ($0.name, $0.value ?? "")
        }
    }
    
    private func redirectSignIn(module: inout SignInViewControllable, url: String) {
        module.skipAnimation = true
        for item in parseParameter(url: url) {
            if item.query == "state" {
                module.requestState = item.value
                continue
            }
            
            if item.query == "code" {
                module.accessCode = item.value
                continue
            }
        }
    }
}


