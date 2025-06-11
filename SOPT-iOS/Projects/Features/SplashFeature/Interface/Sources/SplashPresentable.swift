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
public protocol SplashCoordinatable {
    var onNoticeSkipped: (() -> Void)? { get set }
    var onNoticeExist: ((AppNoticeModel) -> Void)? { get set }
    var checkSignInFlow: (() -> Void)? { get set }
}

public typealias LegacySplashPresentable = (vc: SplashViewControllable, vm: any ViewModelType)

public typealias SplashPresentable = (vc: UIViewController, vm: any ViewModelType)
