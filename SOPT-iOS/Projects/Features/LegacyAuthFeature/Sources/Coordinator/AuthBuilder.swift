//
//  AuthBuilder.swift
//  AuthFeatureTests
//
//  Created by Junho Lee on 2023/06/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import LegacyAuthFeatureInterface

public class LegacyAuthBuilder: LegacyAuthFeatureBuildable {
    @Injected public var repository: SignInRepositoryInterface
    @Injected public var oauthRepository: CoreOAuthRepositoryInterface
    @Injected public var coreRepository: CoreAuthRepositoryInterface
    @Injected public var tokenRepository: AuthTokensRepositoryInterface
    
    public init() { }
    
    public func makeSignIn() -> LegacySignInPresentable {
        let useCase = DefaultSignInUseCase(
            repository: repository,
            oauthRepository: oauthRepository,
            coreRepository: coreRepository,
            tokenRepository: tokenRepository
        )
        let vm = LegacySignInViewModel(useCase: useCase)
        let vc = LegacySignInVC()
        vc.viewModel = vm
        return (vc, vm)
    }
}
