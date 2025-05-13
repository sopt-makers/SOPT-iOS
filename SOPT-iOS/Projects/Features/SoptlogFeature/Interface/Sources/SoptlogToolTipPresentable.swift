//
//  SoptlogToolTipPresentable.swift
//  SoptlogFeatureInterface
//
//  Created by 강윤서 on 3/26/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core

public protocol SoptlogToolTipViewControllable: LegacyViewControllable { }
public protocol SoptlogToolTipCoordinatable {
    var onDismissButtonTap: (() -> Void)? { get set }
    var onDimmingBackgroundTap: (() -> Void)? { get set }
}
public typealias SoptlogToolTipViewModelType = ViewModelType & SoptlogToolTipCoordinatable
public typealias LegacySoptlogTooltipPresentable = (vc: SoptlogToolTipViewControllable, vm: any SoptlogToolTipViewModelType)

public typealias SoptlogTooltipPresentable = (vc: UIViewController, vm: any SoptlogToolTipViewModelType)
