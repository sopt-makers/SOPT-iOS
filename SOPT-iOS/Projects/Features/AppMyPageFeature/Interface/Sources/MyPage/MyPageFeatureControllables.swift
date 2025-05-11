//
//  MyPageControllables.swift
//  AppMyPageFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency

public protocol SentenceEditViewControllable: LegacyViewControllable { }
public protocol PrivacyPolicyViewControllable: LegacyViewControllable { }
public protocol TermsOfServiceViewControllable: LegacyViewControllable { }
public protocol WithdrawalViewControllable: LegacyViewControllable & WithdrawalViewCoordinatable {
    var userType: UserType { get set }
}
public protocol WithdrawalViewCoordinatable {
    var onWithdrawal: (() -> Void)? { get set }
}
