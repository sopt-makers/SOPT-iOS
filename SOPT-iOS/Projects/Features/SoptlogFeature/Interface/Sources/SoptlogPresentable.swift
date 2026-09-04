//
//  SoptlogPresentable.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import PokeFeatureInterface

public protocol SoptlogViewControllable: LegacyViewControllable { }
public protocol SoptlogCoordinatable {
    var onToolTipTapped: ((CGRect) -> Void)? { get set }
    var onNetworkError: (@MainActor () -> Void)? { get set }
    var onAuthFailed: (@MainActor () -> Void)? { get set }
    var onSoptampHomeTapped: (() -> Void)? { get set }
    var onPokeHomeTapped: (() -> Void)? { get set }
    var onPokeMyFriendsTapped: ((PokeRelation) -> Void)? { get set }
}
public typealias SoptlogViewModelType = ViewModelType & SoptlogCoordinatable
public typealias LegacySoptlogPresentable = (vc: SoptlogViewControllable, vm: any SoptlogViewModelType)

public typealias SoptlogPresentable = (vc: UIViewController, vm: any SoptlogViewModelType)
