//
//  LegacySplashFeatureBuildable.swift
//  SplashFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency

public protocol LegacySplashFeatureViewBuildable {
    func makeSplash(_ coordinator: Coordinator) -> LegacySplashPresentable
    func makeNoticePopUpVC(noticeType: NoticePopUpType, model: AppNoticeModel) -> LegacyNoticePopUpViewControllable
}
