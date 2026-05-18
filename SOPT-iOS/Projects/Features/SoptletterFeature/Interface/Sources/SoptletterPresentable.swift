//
//  SoptletterPresentable.swift
//  SoptletterFeatureInterface
//
//  Created by 강윤서 on 5/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core

public protocol SoptletterViewControllable: LegacyViewControllable {}

public protocol SoptletterCoordinatable {
    var onNaviBackTap: (() -> Void)? { get set }
    var onSubmitSuccess: (() -> Void)? { get set }
}

public typealias SoptletterWritingViewModelType = ViewModelType & SoptletterCoordinatable
public typealias SoptletterWritingPresentable = (vc: UIViewController, vm: any SoptletterWritingViewModelType)
