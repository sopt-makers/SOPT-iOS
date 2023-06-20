//
//  NoticePopUpViewControllable.swift
//  SplashFeatureInterface
//
//  Created by Junho Lee on 2023/06/20.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import BaseFeatureDependency

public protocol NoticePopUpViewControllable: ViewControllable {
    var closeButtonTappedWithCheck: PassthroughSubject<Bool, Never> { get }
}
