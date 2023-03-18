//
//  SettingFeatureViewControllable.swift
//  SettingFeatureTests
//
//  Created by 김영인 on 2023/03/18.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol SettingViewControllable: ViewControllable { }

public protocol NicknameEditViewControllable: ViewControllable { }

public protocol SentenceEditViewControllable: ViewControllable { }

public protocol PasswordChangeViewControllable: ViewControllable { }

public protocol PrivacyPolicyViewControllable: ViewControllable { }

public protocol TermsOfServiceViewControllable: ViewControllable { }

public protocol WithdrawalViewControllable: ViewControllable { }

public protocol SettingFeatureViewBuildable {
    func makeSettingVC() -> SettingViewControllable
    func makeNicknameEditVC() -> NicknameEditViewControllable
    func makeSentenceEditVC() -> SentenceEditViewControllable
    func makePasswordChangeVC() -> PasswordChangeViewControllable
    func makePrivacyPolicyVC() -> PrivacyPolicyViewControllable
    func makeTermsOfServiceVC() -> TermsOfServiceViewControllable
    func makeWithdrawalVC() -> WithdrawalViewControllable
}
