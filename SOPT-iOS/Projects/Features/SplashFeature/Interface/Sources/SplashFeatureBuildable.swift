//
//  SplashFeatureBuildable.swift
//  SplashFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core

public protocol SplashFeatureViewBuildable {
    func makeSplash() -> SplashPresentable
    func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> NoticePopUpViewControllable
}
