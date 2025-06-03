//
//  NotificationCoordinatorDestination.swift
//  NotificationFeature
//
//  Created by Jae Hyun Lee on 5/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public enum NotificationCoordinatorDestination {
    case deepLink(url: String)
    case webLink(url: String)
}
