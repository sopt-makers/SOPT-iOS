//
//  DailySoptuneResultPresentable.swift
//  DailySoptuneFeatureInterface
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol DailySoptuneResultViewControllable: ViewControllable { }

public protocol DailySoptuneResultCoordinatable {
    var onKokButtonTapped: ((PokeUserModel) -> Driver<(PokeUserModel, PokeMessageModel, isAnonymous: Bool)>)? { get set }
    var onReceiveTodaysFortuneCardButtonTapped: ((DailySoptuneCardModel) -> Void)? { get set }
}

public typealias DailySoptuneResultViewModelType = ViewModelType & DailySoptuneResultCoordinatable
public typealias DailySoptuneResultPresentable = (vc: DailySoptuneResultViewControllable, vm: any DailySoptuneResultViewModelType)
