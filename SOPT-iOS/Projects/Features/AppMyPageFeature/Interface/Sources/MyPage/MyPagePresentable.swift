//
//  MyPagePresentable.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core

public protocol MyPageViewControllable: LegacyViewControllable { }
public protocol MyPageRoutingTrigger {
    var onNaviBackButtonTap: (() -> Void)? { get set }
    var onPolicyItemTap: (() -> Void)? { get set }
    var onTermsOfUseItemTap: (() -> Void)? { get set }
    var onEditOnelineSentenceItemTap: (() -> Void)? { get set }
    var onWithdrawalItemTap: ((UserType) -> Void)? { get set }
    var onShowLogin: (() -> Void)? { get set }
    var onShowLogout: (() -> Void)? { get set }
    var onAlertButtonTap: ((String) -> Void)? { get set }
    var onResetSoptampTap: ((@escaping () -> Void) -> Void)? { get set }
    var onLogoutTap: ((@escaping () -> Void) -> Void)? { get set }
    var onShowSoptlog: (() -> Void)? { get set }
    var onEditProfileTap: (() -> Void)? { get set }
}

public typealias MyPageViewModelType = MyPageRoutingTrigger & ViewModelType
public typealias LegacyMyPagePresentable = (vc: MyPageViewControllable, vm: any MyPageViewModelType)
public typealias MyPagePresentable = (vc: UIViewController, vm: any MyPageViewModelType)
