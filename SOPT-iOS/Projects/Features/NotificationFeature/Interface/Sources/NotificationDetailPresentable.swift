//
//  NotificationDetailPresentable.swift
//  NotificationFeatureInterface
//
//  Created by Junho Lee on 2023/06/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol NotificationDetailViewControllable: LegacyViewControllable { }

public protocol NotificationDetailRoutingTrigger {
    var onShortCutButtonTap: ((ShortCutLink) -> Void)? { get set }
}

public typealias ShortCutLink = (url: String, isDeepLink: Bool)

public typealias NotificationDetailViewModelType = ViewModelType & NotificationDetailRoutingTrigger
public typealias LegacyNotificationDetailPresentable = (vc: NotificationDetailViewControllable, vm: any NotificationDetailViewModelType)

public typealias NotificationDetailPresentable = (vc: UIViewController, vm: any NotificationDetailViewModelType)
