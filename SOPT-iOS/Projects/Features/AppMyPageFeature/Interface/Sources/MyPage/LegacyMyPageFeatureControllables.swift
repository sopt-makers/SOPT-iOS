//
//  LegacyMyPageControllables.swift
//  AppMyPageFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency

public protocol LegacySentenceEditViewControllable: LegacyViewControllable { }
public protocol LegacyPrivacyPolicyViewControllable: LegacyViewControllable { }
public protocol LegacyTermsOfServiceViewControllable: LegacyViewControllable { }
public protocol LegacyWithdrawalViewControllable: LegacyViewControllable & LegacyWithdrawalViewCoordinatable {
    var userType: UserType { get set }
}
public protocol LegacyWithdrawalViewCoordinatable {
    var onWithdrawal: (() -> Void)? { get set }
}
