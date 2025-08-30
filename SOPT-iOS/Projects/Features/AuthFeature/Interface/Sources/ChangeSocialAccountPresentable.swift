//
//  ChangeSocialAccountPresentable.swift
//  AuthFeature
//
//  Created by 장석우 on 5/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol ChangeSocialAccountViewControllable: LegacyViewControllable { }

public protocol ChangeSocialAccountRoutingTrigger {
    var changeSocialAccountSucceed: (() -> Void)? { get set }
}

public typealias ChangeSocialAccountViewModelType = ViewModelType & ChangeSocialAccountRoutingTrigger

public typealias ChangeSocialAccountPresentable = (vc: ChangeSocialAccountViewControllable, vm: any ChangeSocialAccountViewModelType)
