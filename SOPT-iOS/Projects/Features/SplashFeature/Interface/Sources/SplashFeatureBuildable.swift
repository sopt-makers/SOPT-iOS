//
//  SplashFeatureBuildable.swift
//  SplashFeature
//
//  Created by Jae Hyun Lee on 5/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency

public protocol SplashFeatureBuildable {
    func makeSplash(_ coordinator: Coordinator) -> SplashPresentable
    func makeNoticePopUpVC(noticeType: NoticePopUpType, content: String) -> NoticePopUpPresentable
}
