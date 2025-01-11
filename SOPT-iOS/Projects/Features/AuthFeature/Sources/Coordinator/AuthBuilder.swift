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
    
    public init() { }
}

extension AuthBuilder: AuthFeatureViewBuildable {
    
    public func makeSignIn() -> SignInPresentable {
        let useCase = DefaultSignInUseCase(repository: repository)
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
        let useCase = StubPhoneVerifyUseCase() // TODO
        let vm = SignUpViewModel(useCase: useCase)
        let vc = SignUpVC(viewModel: vm)
        return (vc, vm)
    }
}
