//
//  SignInPresentable_Refactor.swift
//  AuthFeature
//
//  Created by 장석우 on 3/7/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Core

public protocol SignInCoordinatable_Refactor: SignInCoordinatable {
    var onLoginHelpButtonTapped: (() -> Void)? { get set }
    var onSocialLoginFail: (() -> Void)? { get set }
    var onSignUpButtonTapped: (() -> Void)? { get set }
}
public typealias SignInViewModelType_Refactor = ViewModelType & SignInCoordinatable_Refactor
public typealias SignInPresentable_Refactor = (vc: SignInViewControllable, vm: any SignInViewModelType_Refactor)
