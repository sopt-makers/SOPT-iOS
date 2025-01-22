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

public
final class AuthBuilder {
    @Injected public var repository: SignInRepositoryInterface
    @Injected public var oauthRepository: CoreOAuthRepositoryInterface
    @Injected public var coreRepository: CoreAuthRepositoryInterface
    @Injected public var phoneRepository: PhoneVerifyRepositoryInterface
    
    public init() { }
}

extension AuthBuilder: AuthFeatureViewBuildable {
    
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
    
    public func makeLoginHelpBottomSheet() -> LoginHelpBottomSheetPresentable {
        return LoginHelpBottomSheetVC()
    }
    
    public func makeUserNotFound() -> UserNotFoundPresentable {
         return UserNotFoundVC()
    }
    
    public func makeSignUp() -> SignUpPresentable {
        let phoneUseCase = DefaultPhoneVerifyUseCase(repository: phoneRepository)
        let phoneVM = PhoneVerifyViewModel(useCase: phoneUseCase)
        
        let useCase = DefaultSignUpUseCase(repository: coreRepository, oAuthRepository: oauthRepository) 
        let vm = SignUpViewModel(useCase: useCase)
        
        let vc = SignUpVC(viewModel: vm, phoneVerifyViewModel: phoneVM)
        return (vc, vm)
    }
}
