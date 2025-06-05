//
//  LegacyMyPageFeatureBuildable.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

public protocol LegacyMyPageFeatureBuildable {
    func makeAppMyPage(userType: UserType) -> LegacyMyPagePresentable
    func makeSentenceEditVC() -> LegacySentenceEditViewControllable
    func makePrivacyPolicyVC() -> LegacyPrivacyPolicyViewControllable
    func makeTermsOfServiceVC() -> LegacyTermsOfServiceViewControllable
    func makeWithdrawalVC(userType: UserType) -> LegacyWithdrawalViewControllable
    func makeAlertSettingByFeatures() -> NotificationSettingByFeaturesViewControllable
}
