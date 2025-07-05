//
//  MyPageFeatureBuildable.swift
//  AppMyPageFeature
//
//  Created by 강윤서 on 6/4/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Core
import BaseFeatureDependency

public protocol MyPageFeatureBuildable {
    func makeAppMyPage(userType: UserType, coordinator: Coordinator) -> MyPagePresentable
    func makeSentenceEditVC() -> UIViewController
    func makePrivacyPolicyVC() -> UIViewController
    func makeTermsOfServiceVC() -> UIViewController
    func makeWithdrawalVC(userType: UserType) -> WithdrawalPresentable
}
