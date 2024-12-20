//
//  SignUpPhoneVerifyViewControllable.swift
//  AuthFeature
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol SignUpPhoneVerifyViewControllable: ViewControllable {}

public protocol SignUpPhoneVerifyCoordinatable {}

public typealias SignUpPhoneVerifyViewModelType = ViewModelType & SignUpPhoneVerifyCoordinatable
public typealias SignUpPhoneVerifyPresentable = (vc: SignUpPhoneVerifyViewControllable, vm: any SignUpPhoneVerifyViewModelType)
