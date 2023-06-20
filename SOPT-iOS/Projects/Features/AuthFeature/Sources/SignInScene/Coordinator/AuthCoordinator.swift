//
//  AuthCoordinator.swift
//  AuthFeatureTests
//
//  Created by Junho Lee on 2023/06/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

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
    
    public init(router: Router, factory: AuthFeatureViewBuildable) {
        self.factory = factory
        self.router = router
    }
    
    public override func start(by style: CoordinatorStartingOption) {
        var signIn = factory.makeSignIn()
        
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
        }
    }
}
