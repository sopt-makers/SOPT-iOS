//
//  SignUpPhoneVerifyViewControllable.swift
//  AuthFeature
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol SignUpViewControllable: LegacyViewControllable {}

public protocol SignUpRoutingTrigger {
    var onSignUpSuccess: (() -> Void)? { get set }
    var onLoginHelpButtonTapped: (() -> Void)? { get set }
}

public typealias PhoneVerifyViewModelType = ViewModelType

public typealias SignUpViewModelType = ViewModelType & SignUpRoutingTrigger

public typealias SignUpPresentable = (vc: UIViewController, vm: any SignUpViewModelType)
