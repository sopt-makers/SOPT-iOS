//
//  NotificationListPresentable.swift
//  NotificationFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency
import Core
import Domain

public protocol NotificationListViewControllable: ViewControllable { }
public protocol NotificationListCoordinatable {
    var onNaviBackButtonTap: (() -> Void)? { get set }
    var onNotificationTap: ((String) -> Void)? { get set }
}
public typealias NotificationListViewModelType = ViewModelType & NotificationListCoordinatable
public typealias NotificationListPresentable = (vc: NotificationListViewControllable, vm: any NotificationListViewModelType)
