//
//  DailySoptuneResultPresentable.swift
//  DailySoptuneFeatureInterface
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol DailySoptuneResultViewControllable: LegacyViewControllable { }

public protocol DailySoptuneResultCoordinatable {
    var onNaviBackButtonTapped: (() -> Void)? { get set }
    var onKokButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)? { get set }
    var onReceiveTodaysFortuneCardButtonTapped: ((DailySoptuneCardModel) -> Void)? { get set }
    var onProfileImageTapped: ((Int) -> Void)? { get set }
}

public typealias LegacyDailySoptuneResultPresentable = (vc: DailySoptuneResultViewControllable, vm: any ViewModelType)
public typealias DailySoptuneResultPresentable = (vc: UIViewController, vm: any ViewModelType)
