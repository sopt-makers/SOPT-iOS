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

public protocol AuthCoordinatorFinishOutput {
    var finishFlow: ((UserType) -> Void)? { get set }
}

public typealias DefaultAuthCoordinator = BaseCoordinator & AuthCoordinatorFinishOutput

public
final class AuthCoordinator: DefaultAuthCoordinator {
    
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
            case .unregistedProfile:
                self?.finishFlow?(.unregisteredInactive)
            case .loginFailure: break
            }
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
        case .rootWindow:
            router.setRootWindow(signIn.vc)
        case .push: break
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
}
