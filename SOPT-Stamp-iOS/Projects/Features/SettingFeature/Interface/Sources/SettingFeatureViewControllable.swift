//
//  SettingFeatureViewControllable.swift
//  SettingFeatureTests
//
//  Created by 김영인 on 2023/03/18.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol SettingFeatureViewControllable: ViewControllable { }

public protocol SettingFeatureViewBuildable {
    func makeSettingVC() -> SettingFeatureViewControllable
    func makeNicknameEditVC() -> SettingFeatureViewControllable
    func makeSentenceEditVC() -> SettingFeatureViewControllable
    func makePasswordChangeVC() -> SettingFeatureViewControllable
    func makePrivacyPolicyVC() -> SettingFeatureViewControllable
    func makeTermsOfServiceVC() -> SettingFeatureViewControllable
    func makeWithdrawalVC() -> SettingFeatureViewControllable
}
