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

public protocol SignUpViewControllable: ViewControllable {}

public protocol SignUpCoordinatable {
}

public typealias SignUpViewModelType = ViewModelType & SignUpCoordinatable
public typealias SignUpPresentable = (vc: SignUpViewControllable, vm: any SignUpViewModelType)
