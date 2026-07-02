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

public protocol SelectTopicCoordinatable {
    var onNaviBackTap: (() -> Void)? { get set }
    var onCellTap: ((String) -> Void)? { get set }
}

public protocol SoptletterDetailCoordinatorble {
    var onNaviBackTap: (() -> Void)? { get set }
}

public typealias SoptletterWritingViewModelType = ViewModelType & SoptletterCoordinatable
public typealias SoptletterDetailViewModelType = ViewModelType & SoptletterDetailCoordinatorble
public typealias SoptletterWritingPresentable = (vc: UIViewController, vm: any SoptletterWritingViewModelType)
public typealias SoptletterDetailPresentable = (vc: UIViewController, vm: any SoptletterDetailViewModelType)

public typealias SelectTopicPresentable = UIViewController & SelectTopicCoordinatable
