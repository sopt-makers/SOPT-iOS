//
//  StampGuidePresentable.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import Core
import BaseFeatureDependency
import Domain

public protocol LegacyStampGuideViewControllable: LegacyViewControllable {
    var onNaviBackTap: (() -> Void)? { get set }
}
public protocol StampGuideViewControllable: UIViewController {
    var onNaviBackTap: (() -> Void)? { get set }
}
