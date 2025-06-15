//
//  DailySoptuneMainPresentable.swift
//  DailySoptuneFeatureInterface
//
//  Created by 강윤서 on 9/26/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol DailySoptuneMainViewControllable: LegacyViewControllable {}

public protocol DailySoptuneMainCoordinatable {
    var onNaviBackTap: (() -> Void)? { get set }
    var onReciveTodayFortuneButtonTap: ((DailySoptuneResultModel) -> Void)? { get set }
}

public typealias LegacyDailySoptuneMainPresentable = (vc: DailySoptuneMainViewControllable, vm: any ViewModelType)
public typealias DailySoptuneMainPresentable = (vc: UIViewController, vm: any ViewModelType)
