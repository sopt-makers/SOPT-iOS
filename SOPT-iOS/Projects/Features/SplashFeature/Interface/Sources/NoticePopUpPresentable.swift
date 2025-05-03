//
//  NoticePopUpPresentable.swift
//  SplashFeature
//
//  Created by Jae Hyun Lee on 5/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit
import Combine

import BaseFeatureDependency

public protocol NoticePopUpViewControllable {
    var closeButtonTappedWithCheck: PassthroughSubject<Bool, Never> { get }
}

public typealias NoticePopUpPresentable = (UIViewController & NoticePopUpViewControllable)
