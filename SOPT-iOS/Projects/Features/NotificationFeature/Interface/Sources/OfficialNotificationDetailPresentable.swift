//
//  OfficialNotificationDetailPresentable.swift
//  NotificationFeature
//
//  Created by 이나연 on 11/19/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import UIKit

import BaseFeatureDependency
import Core
import Domain

public protocol OfficialNotificationDetailRoutingTrigger {
    var onCheckButtonTap: (() -> Void)? { get set }
    var onLinkButtonTap: ((ShortCutLink) -> Void)? { get set }
    var onCheckedMemberListTap: (() -> Void)? { get set }
    var onZoomInButtonTap: ((String) -> Void)? { get set }
}

public typealias OfficialNotificationDetailPresentable = (vc: UIViewController, vm: any OfficialNotificationDetailRoutingTrigger)
