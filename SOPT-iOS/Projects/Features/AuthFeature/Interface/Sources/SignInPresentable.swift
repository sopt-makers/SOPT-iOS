//
//  SignInPresentable.swift
//  AuthFeature
//
//  Created by 장석우 on 3/7/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Foundation
import BaseFeatureDependency
import Core

public protocol SignInViewControllable: LegacyViewControllable { }

public protocol SignInRoutingTrigger {
    var onLoginHelpButtonTapped: (() -> Void)? { get set }
    var onSocialLoginFail: (() -> Void)? { get set }
    var onSignUpButtonTapped: (() -> Void)? { get set }
    var onSignInSuccess: (() -> Void)? { get set }
    var onVisitorButtonTapped: (() -> Void)? { get set }
}

public typealias SignInViewModelType = ViewModelType & SignInRoutingTrigger

public typealias SignInPresentable = (vc: UIViewController, vm: any SignInViewModelType)
