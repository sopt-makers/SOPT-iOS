//
//  AuthBuilder_Refactor.swift
//  AuthFeature
//
//  Created by 장석우 on 3/7/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import AuthFeatureInterface

public final class AuthBuilder_Refactor: AuthFeatureViewBuildable_Refactor {
    
    @Injected public var repository: SignInRepositoryInterface
    @Injected public var oauthRepository: CoreOAuthRepositoryInterface
    @Injected public var coreRepository: CoreAuthRepositoryInterface
    @Injected public var phoneRepository: PhoneVerifyRepositoryInterface
    
    public init() { }
    
    public func makeSignIn() -> SignInPresentable_Refactor {
        let useCase = DefaultSignInUseCase(repository: repository,
                                           oauthRepository: oauthRepository,
                                           coreRepository: coreRepository)
        let vm = SignInViewModel_Refactor(useCase: useCase)
        let vc = SignInVC_Refactor()
        vc.viewModel = vm
        return (vc, vm)
    }

    public func makeLoginHelpBottomSheet() -> LoginHelpBottomSheetPresentable {
        return LoginHelpBottomSheetVC()
    }
    
    public func makeUserNotFound() -> UserNotFoundPresentable {
         return UserNotFoundVC()
    }
    
    public func makeSignUp() -> SignUpPresentable {
        let useCase = DefaultSignUpUseCase(repository: coreRepository, oAuthRepository: oauthRepository)
        let phoneUseCase = DefaultPhoneVerifyUseCase(repository: phoneRepository)
        
        let vm = SignUpViewModel(useCase: useCase)
        let phoneVM = PhoneVerifyViewModel(useCase: phoneUseCase)
        let vc = SignUpVC(viewModel: vm, phoneVerifyViewModel: phoneVM)
        
        return (vc, vm)
    }
    
}
