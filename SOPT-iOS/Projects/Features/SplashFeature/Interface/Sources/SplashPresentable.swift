//
//  SplashFeatureViewControllable.swift
//  SplashFeatureInterface
//
//  Created by 김영인 on 2023/03/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import BaseFeatureDependency

public protocol SplashViewControllable: ViewControllable { }
public protocol SplashCoordinatable {
    var onNoticeSkipped: (() -> Void)? { get set }
    var onNoticeExist: ((AppNoticeModel) -> Void)? { get set }
}
public typealias SplashViewModelType = ViewModelType & SplashCoordinatable
public typealias SplashPresentable = (vc: SplashViewControllable, vm: any SplashViewModelType)
