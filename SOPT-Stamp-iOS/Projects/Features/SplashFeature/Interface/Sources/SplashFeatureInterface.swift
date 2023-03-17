//
//  SplashFeatureInterface.swift
//  SplashFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import BaseFeatureDependency

public protocol SplashFeatureInterface: ViewRepresentable { }

public protocol SplashFeature {
    func makeSplashVC() -> SplashFeatureInterface
    func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> SplashFeatureInterface
}
