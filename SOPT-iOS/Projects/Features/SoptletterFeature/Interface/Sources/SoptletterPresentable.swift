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

public protocol SoptletterOnboardingViewControllable: AnyObject {
    var onNaviBackTap: (() -> Void)? { get set }
    var onStartButtonTap: (() -> Void)? { get set }
}

public protocol SoptletterNicknameCheckViewControllable: AnyObject {
    var onNaviBackTap: (() -> Void)? { get set }
    var onGoButtonTap: (() -> Void)? { get set }
}

public protocol SoptletterCoordinatable {
    var onNaviBackTap: (() -> Void)? { get set }
    var onSubmitSuccess: (() -> Void)? { get set }
}

public typealias SoptletterOnboardingPresentable = UIViewController & SoptletterOnboardingViewControllable

public typealias SoptletterNicknameCheckPresentable = UIViewController & SoptletterNicknameCheckViewControllable

public typealias SoptletterWritingViewModelType = ViewModelType & SoptletterCoordinatable
public typealias SoptletterWritingPresentable = (vc: UIViewController, vm: any SoptletterWritingViewModelType)
