//
//  MyPagePresentable.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core

public protocol MyPageViewControllable: LegacyViewControllable & MyPageCoordinatable { }
public protocol MyPageCoordinatable {
    var onNaviBackButtonTap: (() -> Void)? { get set }
    var onPolicyItemTap: (() -> Void)? { get set }
    var onTermsOfUseItemTap: (() -> Void)? { get set }
    var onEditOnelineSentenceItemTap: (() -> Void)? { get set }
    var onWithdrawalItemTap: ((UserType) -> Void)? { get set }
    var onShowLogin: (() -> Void)? { get set }
    var onAlertButtonTap: ((String) -> Void)? { get set }
}
public typealias MyPageViewModelType = ViewModelType
