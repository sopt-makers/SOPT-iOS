//
//  NotificationListPresentable.swift
//  NotificationFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol NotificationListViewControllable: LegacyViewControllable { }
public protocol NotificationListRoutingTrigger {
    var onNaviBackButtonTap: (() -> Void)? { get set }
    var onNotificationTap: ((String) -> Void)? { get set }
}
public typealias NotificationListViewModelType = ViewModelType & NotificationListRoutingTrigger
public typealias LegacyNotificationListPresentable = (vc: NotificationListViewControllable, vm: any NotificationListViewModelType)

public typealias NotificationListPresentable = (vc: UIViewController, vm: any NotificationListViewModelType)
