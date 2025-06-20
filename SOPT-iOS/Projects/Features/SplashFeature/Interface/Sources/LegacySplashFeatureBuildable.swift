//
//  LegacySplashFeatureBuildable.swift
//  SplashFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

public protocol LegacySplashFeatureViewBuildable {
    func makeSplash(_ coordinator: SplashCoordinatable) -> LegacySplashPresentable
    func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> LegacyNoticePopUpViewControllable
}
