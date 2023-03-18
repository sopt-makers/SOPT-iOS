//
//  SplashFeatureViewControllable.swift
//  SplashFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import BaseFeatureDependency

public protocol SplashViewControllable: ViewControllable { }

public protocol NoticePopUpViewControllable: ViewControllable {
    var closeButtonTappedWithCheck: PassthroughSubject<Bool, Never> { get }
}

public protocol SplashFeatureViewBuildable {
    func makeSplashVC() -> SplashViewControllable
    func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> NoticePopUpViewControllable
}
