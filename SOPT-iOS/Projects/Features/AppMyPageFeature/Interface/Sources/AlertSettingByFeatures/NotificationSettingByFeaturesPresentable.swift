//
//  NotificationSettingByFeaturesPresentable.swift
//  AppMyPageFeatureInterface
//
//  Created by Ian on 2023/09/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core

public protocol NotificationSettingByFeaturesViewControllable:
    ViewControllable & NotificationSettingByFeaturesCoordiatable { }
public protocol NotificationSettingByFeaturesCoordiatable {
    var onNaviBackButtonTap: (() -> Void)? { get set }
}

public typealias NotificationSettingByFeaturesViewModelType = ViewModelType
