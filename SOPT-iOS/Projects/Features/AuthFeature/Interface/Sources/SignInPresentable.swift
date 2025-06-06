//
//  SignInPresentable.swift
//  AuthFeature
//
//  Created by 장석우 on 3/7/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Core

public protocol SignInViewControllable: LegacyViewControllable { }

public protocol SignInCoordinatable {
    var onLoginHelpButtonTapped: (() -> Void)? { get set }
    var onSocialLoginFail: (() -> Void)? { get set }
    var onSignUpButtonTapped: (() -> Void)? { get set }
    var onSignInSuccess: (() -> Void)? { get set }
    var onVisitorButtonTapped: (() -> Void)? { get set }
}

public typealias SignInViewModelType = ViewModelType & SignInCoordinatable

public typealias SignInPresentable = (vc: SignInViewControllable, vm: any SignInViewModelType)
