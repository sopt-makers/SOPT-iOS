//
//  MyPageControllables.swift
//  AppMyPageFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency

public protocol NicknameEditViewControllable: ViewControllable { }
public protocol SentenceEditViewControllable: ViewControllable { }
public protocol PrivacyPolicyViewControllable: ViewControllable { }
public protocol TermsOfServiceViewControllable: ViewControllable { }
public protocol WithdrawalViewControllable: ViewControllable {
    var userType: UserType { get set }
}
