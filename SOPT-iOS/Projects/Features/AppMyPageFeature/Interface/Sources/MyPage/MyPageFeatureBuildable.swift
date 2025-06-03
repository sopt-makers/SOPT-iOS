//
//  MyPageFeatureBuildable.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/4/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core

public protocol MyPageFeatureBuildable {
    func makeAppMyPage(userType: UserType) -> MyPagePresentable
    func makeSentenceEditVC() -> SentenceEditViewControllable
    func makePrivacyPolicyVC() -> PrivacyPolicyViewControllable
    func makeTermsOfServiceVC() -> TermsOfServiceViewControllable
    func makeWithdrawalVC(userType: UserType) -> WithdrawalViewControllable
    func makeAlertSettingByFeatures() -> NotificationSettingByFeaturesViewControllable
}
