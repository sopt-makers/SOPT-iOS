//
//  AuthBuilder.swift
//  AuthFeature
//
//  Created by 장석우 on 3/7/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain

@_exported import AuthFeatureInterface
import BaseFeatureDependency

public final class AuthBuilder: AuthFeatureViewBuildable {
    
    @Injected public var repository: SignInRepositoryInterface
    @Injected public var oauthRepository: CoreOAuthRepositoryInterface
    @Injected public var coreRepository: CoreAuthRepositoryInterface
    @Injected public var phoneRepository: PhoneVerifyRepositoryInterface
    @Injected public var tokenRepository: AuthTokensRepositoryInterface
    
    public init() { }
    
    public func makeSignIn() -> SignInPresentable {
        let useCase = DefaultSignInUseCase(
            repository: repository,
            oauthRepository: oauthRepository,
            coreRepository: coreRepository,
            tokenRepository: tokenRepository
        )
        let vm = SignInViewModel(useCase: useCase)
        let vc = SignInVC(viewModel: vm)
        return (vc, vm)
    }
    
    public func makeLoginHelpBottomSheet() -> LoginHelpBottomSheetPresentable {
        return LoginHelpBottomSheetVC()
    }
    
    public func makeUserNotFound() -> UserNotFoundPresentable {
        return UserNotFoundVC()
    }
    
    public func makeSignUp() -> SignUpPresentable {
        let useCase = DefaultSignUpUseCase(
            repository: coreRepository,
            oAuthRepository: oauthRepository,
            tokenRepositroy: tokenRepository
        )
        let phoneUseCase = DefaultPhoneVerifyUseCase(repository: phoneRepository)
        
        let vm = SignUpViewModel(useCase: useCase)
        let phoneVM = PhoneVerifyViewModel(useCase: phoneUseCase, phoneVerifyType: .register)
        let vc = SignUpVC(viewModel: vm, phoneVerifyViewModel: phoneVM)
        
        return (vc, vm)
    }
    
    public func makeChangeSocialAccount() -> ChangeSocialAccountPresentable {
        let useCase = DefaultChangeSocialAccountUseCase(
            repository: coreRepository,
            oAuthRepository: oauthRepository,
            tokenRepository: tokenRepository
        )
        
        let phoneUseCase = DefaultPhoneVerifyUseCase(repository: phoneRepository)
        
        let vm = ChangeSocialAccountViewModel(useCase: useCase)
        let phoneVM = PhoneVerifyViewModel(useCase: phoneUseCase, phoneVerifyType: .changeSocialAccount)
        let vc = ChangeSocialAccountVC(viewModel: vm, phoneVerifyViewModel: phoneVM)
        return (vc, vm)
    }
    
    public func makeSearchSocialAccount() -> SearchSocialAccountPresentable {
        let useCase = DefaultSearchSocialAccountUseCase(
            repository: coreRepository
        )
        
        let phoneUseCase = DefaultPhoneVerifyUseCase(repository: phoneRepository)
        
        let vm = SearchSocialAccountViewModel(useCase: useCase)
        let phoneVM = PhoneVerifyViewModel(useCase: phoneUseCase, phoneVerifyType: .searchSocialAccount)
        let vc = SearchSocialAccountVC(viewModel: vm, phoneVerifyViewModel: phoneVM)
        return (vc, vm)
    }
    
}
