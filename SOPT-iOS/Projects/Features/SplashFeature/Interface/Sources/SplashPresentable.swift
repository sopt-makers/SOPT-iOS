//
//  SplashPresentable.swift
//  SplashFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import Domain
import BaseFeatureDependency

public protocol SplashViewControllable: LegacyViewControllable { }
public protocol SplashRoutingTrigger {
    var onNoticeSkipped: (() -> Void)? { get set }
    var onOptionalNoticeExist: ((AppNoticeModel) -> Void)? { get set }
    var onNoticeExist: ((AppNoticeModel) -> Void)? { get set }
    var finished: (() -> Void)? { get set }
}

public typealias SplashViewModelType = SplashRoutingTrigger & ViewModelType
public typealias LegacySplashPresentable = (vc: SplashViewControllable, vm: any SplashViewModelType)
public typealias SplashPresentable = (vc: UIViewController, vm: any SplashViewModelType)
