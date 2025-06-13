//
//  SplashFeatureBuildable.swift
//  SplashFeature
//
//  Created by Jae Hyun Lee on 5/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core

public protocol SplashFeatureBuildable {
    func makeSplash(_ coordinator: SplashCoordinatable) -> SplashPresentable
    func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> NoticePopUpPresentable
}
