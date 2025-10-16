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

public protocol LoginHelpBottomSheetRoutingTrigger: LegacyViewControllable {
    var onWantToKnowLoginAccountButtonDidTap: (() -> Void)? { get set }
    var onResetSocialAccountButtonDidTap: (() -> Void)? { get set }
    var onInquireToKakaoTalkButtonDidTap: (() -> Void)? { get set }
}

public typealias LoginHelpBottomSheetPresentable = LoginHelpBottomSheetRoutingTrigger
