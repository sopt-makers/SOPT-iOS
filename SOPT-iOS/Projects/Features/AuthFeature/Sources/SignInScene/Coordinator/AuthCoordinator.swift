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
        
        signIn.vm.onSignInSuccess = { [weak self] type in
            switch type {
            case .loginSuccess:
                let userType = UserDefaultKeyList.Auth.getUserType()
                self?.finishFlow?(userType)
            case .loginFailure: break
            }
        }
        
        signIn.vm.loginHelpButtonTapped = { [weak self] in
            guard let bottomSheetVC = self?.factory.makeLoginHelpBottomSheet().viewController as? LoginHelpBottomSheetVC
            else { return Void() }
            
            bottomSheetVC.resetSocialAccountButtonDidTap = {
                print("resetSocialAccountButtonDidTap")
            }
            
            bottomSheetVC.wantToKnowLoginAccountButtonDidTap = {
                print("wantToKnowLoginAccountButtonDidTap")
            }
            
            let bottomSheetManager = BottomSheetManager(configuration: .fixed(minHeight: bottomSheetVC.minimumContentHeight,
                                                                              prefersGrabberVisible: false))
            
            
            
            self?.router.showBottomSheet(manager: bottomSheetManager,
                                         toPresent: bottomSheetVC,
                                         on: signIn.vc.viewController)
        }
        
        signIn.vm.onVisitorButtonTapped = { [weak self] in
            self?.finishFlow?(.visitor)
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
            router.setRootModule(signIn.vc, animated: true)
        case .rootWindow(let animated, let message):
            guard !animated else {
                router.setRootWindow(signIn.vc)
                return
            }
            
            guard let message else {
                router.replaceRootWindow(signIn.vc, withAnimation: true)
                return
            }
            
            router.replaceRootWindow(signIn.vc, withAnimation: true) { newWindow in
                Toast.show(
                    message: message,
                    view: newWindow
                )
            }
        case .push: break
        }
    }
}
