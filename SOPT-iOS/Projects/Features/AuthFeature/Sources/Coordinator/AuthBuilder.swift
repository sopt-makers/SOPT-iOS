//
//  AuthBuilder.swift
//  AuthFeatureTests
//
//  Created by Junho Lee on 2023/06/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import AuthFeatureInterface

public class AuthBuilder: AuthFeatureViewBuildable {
    @Injected public var repository: SignInRepositoryInterface
    @Injected public var oauthRepository: CoreOAuthRepositoryInterface
    @Injected public var coreRepository: CoreAuthRepositoryInterface
    
    public init() { }
    
    public func makeSignIn() -> SignInPresentable {
        let useCase = DefaultSignInUseCase(
            repository: repository,
            oauthRepository: oauthRepository,
            coreRepository: coreRepository
        )
        let vm = SignInViewModel(useCase: useCase)
        let vc = SignInVC()
        vc.viewModel = vm
        return (vc, vm)
    }
}
