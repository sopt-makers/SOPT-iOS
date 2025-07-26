//
//  AuthCoordinator.swift
//  AuthFeatureTests
//
//  Created by Junho Lee on 2023/06/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import LegacyAuthFeatureInterface
import AuthFeatureInterface
import Core
import DSKit


public
final class LegacyAuthCoordinator: DefaultAuthCoordinator {
    
    public var finishFlow: ((UserType) -> Void)?
    
    private let factory: LegacyAuthFeatureBuildable
    private let router: LegacyRouter
    private var url: String?
    
    public init(router: LegacyRouter, factory: LegacyAuthFeatureBuildable, url: String? = nil) {
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
    
    private func redirectSignIn(module: inout LegacySignInViewControllable, url: String) {
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

extension LegacyAuthCoordinator {
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
