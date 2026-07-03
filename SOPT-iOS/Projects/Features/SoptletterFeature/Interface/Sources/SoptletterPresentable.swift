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
import Domain

public protocol SoptletterViewControllable: LegacyViewControllable {}

public protocol SoptletterOnboardingRoutingTrigger: AnyObject {
    var onNaviBackTap: (() -> Void)? { get set }
    var onStartButtonTap: (() -> Void)? { get set }
}

public protocol SoptletterNicknameCheckRoutingTrigger: AnyObject {
    var onNaviBackTap: (() -> Void)? { get set }
    var onGoButtonTap: (() -> Void)? { get set }
}

public protocol SoptletterCoordinatable {
    var onNaviBackTap: (() -> Void)? { get set }
    var onSubmitSuccess: (() -> Void)? { get set }
}

public protocol SelectTopicRoutingTrigger {
    var onNaviBackTap: (() -> Void)? { get set }
    var onCellTap: ((SoptletterTopicModel) -> Void)? { get set }
    var showAlert: (() -> Void)? { get set }
}

public typealias SoptletterOnboardingPresentable = (vc: UIViewController, vm: any SoptletterOnboardingViewModelType)
public typealias SoptletterOnboardingViewModelType = ViewModelType & SoptletterOnboardingRoutingTrigger

public typealias SoptletterNicknameCheckPresentable = (vc: UIViewController, vm: any SoptletterNicknameCheckViewModelType)
public typealias SoptletterNicknameCheckViewModelType = ViewModelType & SoptletterNicknameCheckRoutingTrigger

public typealias SoptletterWritingViewModelType = ViewModelType & SoptletterCoordinatable
public typealias SoptletterWritingPresentable = (vc: UIViewController, vm: any SoptletterWritingViewModelType)

public typealias SelectTopicViewModelType = ViewModelType & SelectTopicRoutingTrigger
public typealias SelectTopicPresentable = (vc: UIViewController, vm: any SelectTopicViewModelType)
