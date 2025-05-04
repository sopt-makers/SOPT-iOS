//
//  SoptlogFeatureBuildable.swift
//  SoptlogFeatureInterface
//
//  Created by Jae Hyun Lee on 5/5/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol SoptlogFeatureBuildable {
    func makeSoptlog() -> SoptlogPresentable
    func makeSoptlogToolTip(_ toolTipFrame: CGRect) -> SoptlogTooltipPresentable
}
