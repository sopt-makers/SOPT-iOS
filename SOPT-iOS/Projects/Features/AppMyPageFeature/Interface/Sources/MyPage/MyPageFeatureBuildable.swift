//
//  MyPageFeatureBuildable.swift
//  AppMyPageFeature
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

public protocol MyPageFeatureBuildable {
    func makeAppMyPage(userType: UserType) -> MyPageViewControllable
    func makeSentenceEditVC() -> SentenceEditViewControllable
    func makePrivacyPolicyVC() -> PrivacyPolicyViewControllable
    func makeTermsOfServiceVC() -> TermsOfServiceViewControllable
    func makeWithdrawalVC(userType: UserType) -> WithdrawalViewControllable
    func makeAlertSettingByFeatures() -> NotificationSettingByFeaturesViewControllable
}
