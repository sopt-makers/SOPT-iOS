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


final class AuthBuilder_Refactor: AuthBuilder {
    
    func makeSignIn() -> SignInPresentable_Refactor {
        let useCase = DefaultSignInUseCase(repository: repository)
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
}
