//
//  LoginHelpBottomSheetPresentable.swift
//  AuthFeature
//
//  Created by 장석우 on 10/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol LoginHelpBottomSheetViewControllable: ViewControllable { 
    var wantToKnowLoginAccountButtonDidTap: (() -> Void)? { get set }
    var resetSocialAccountButtonDidTap: (() -> Void)? { get set }
}

public typealias LoginHelpBottomSheetPresentable = LoginHelpBottomSheetViewControllable
