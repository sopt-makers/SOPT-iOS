//
//  SoptlogFeatureBuildable.swift
//  SoptlogFeatureInterface
//
//  Created by Jae Hyun Lee on 5/5/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public protocol SoptlogFeatureBuildable {
    func makeSoptlog(coordinator: Coordinator) -> SoptlogPresentable
    func makeSoptlogToolTip(_ toolTipFrame: CGRect) -> SoptlogTooltipPresentable
}
