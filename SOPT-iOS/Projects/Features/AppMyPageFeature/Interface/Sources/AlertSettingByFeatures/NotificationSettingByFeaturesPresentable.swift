//
//  NotificationSettingByFeaturesPresentable.swift
//  AppMyPageFeatureInterface
//
//  Created by Ian on 2023/09/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//
// NOTE: 현재 코드에서 사용되지 않는 화면(기능별 알림 설정)입니다.
// 추후 재사용 가능성이 있어 삭제하지 않고 남겨둡니다.

import BaseFeatureDependency
import Core

public protocol NotificationSettingByFeaturesViewControllable: NotificationSettingByFeaturesCoordiatable { }
public protocol NotificationSettingByFeaturesCoordiatable {
    var onNaviBackButtonTap: (() -> Void)? { get set }
}

public typealias NotificationSettingByFeaturesViewModelType = ViewModelType
