//
//  SoptlogToolTipPresentable.swift
//  SoptlogFeatureInterface
//
//  Created by 강윤서 on 3/26/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import Core

public protocol SoptlogToolTipViewControllable: ViewControllable { }
public protocol SoptlogToolTipCoordinatable {
    var onDismissButtonTap: (() -> Void)? { get set }
    var onDimmingBackgroundTap: (() -> Void)? { get set }
}
public typealias SoptlogToolTipViewModelType = ViewModelType & SoptlogToolTipCoordinatable
public typealias SoptlogTooltipPresentable = (vc: SoptlogToolTipViewControllable, vm: any SoptlogToolTipViewModelType)
