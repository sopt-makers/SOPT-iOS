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

// SoptletterOnboarding

public protocol SoptletterOnboardingRoutingTrigger: AnyObject {
    var onNaviBackTap: (() -> Void)? { get set }
    var onStartButtonTap: (() -> Void)? { get set }
}

public typealias SoptletterOnboardingViewModelType = ViewModelType & SoptletterOnboardingRoutingTrigger
public typealias SoptletterOnboardingPresentable = (vc: UIViewController, vm: any SoptletterOnboardingViewModelType)

// SoptletterNicknameCheck

public protocol SoptletterNicknameCheckRoutingTrigger: AnyObject {
    var onNaviBackTap: (() -> Void)? { get set }
    var onGoButtonTap: (() -> Void)? { get set }
    var showAlert: (() -> Void)? { get set }
}

public typealias SoptletterNicknameCheckViewModelType = ViewModelType & SoptletterNicknameCheckRoutingTrigger
public typealias SoptletterNicknameCheckPresentable = (vc: UIViewController, vm: any SoptletterNicknameCheckViewModelType)

// SoptletterWriting

public protocol SoptletterWritingRoutingTrigger {
    var onNaviBackTap: (() -> Void)? { get set }
    var onSubmitSuccess: (@MainActor () -> Void)? { get set }
}

public typealias SoptletterWritingViewModelType = ViewModelType & SoptletterWritingRoutingTrigger
public typealias SoptletterWritingPresentable = (vc: UIViewController, vm: any SoptletterWritingViewModelType)

// SoptletterDetail

public protocol SoptletterDetailRoutingTrigger {
    var onError: (@MainActor () -> Void)? { get set }
    var onEditCompleted: (() -> Void)? { get set }
    var onDeleteCompleted: (() -> Void)? { get set }
}

public typealias SoptletterDetailViewModelType = ViewModelType & SoptletterDetailRoutingTrigger
public typealias SoptletterDetailPresentable = (vc: UIViewController, vm: any SoptletterDetailViewModelType)

// SoptletterPrinting

public protocol SoptletterPrintRoutingTrigger {
    var onNaviBackTap: (() -> Void)? { get set }
    var onPDFSaveTap: ((URL) -> Void)? { get set }
}

public typealias SoptletterPrintViewModelType = ViewModelType & SoptletterPrintRoutingTrigger
public typealias SoptletterPrintPresentable = (vc: UIViewController, vm: any SoptletterPrintViewModelType)

// SoptletterTopic

public protocol SelectTopicRoutingTrigger {
    var onNaviBackTap: (() -> Void)? { get set }
    var onCellTap: ((SoptletterTopicModel) -> Void)? { get set }
    var showAlert: (() -> Void)? { get set }
}

public typealias SelectTopicViewModelType = ViewModelType & SelectTopicRoutingTrigger
public typealias SelectTopicPresentable = (vc: UIViewController, vm: any SelectTopicViewModelType)
