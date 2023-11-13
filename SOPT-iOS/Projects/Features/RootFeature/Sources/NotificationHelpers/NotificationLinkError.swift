//
//  NotificationLinkError.swift
//  RootFeature
//
//  Created by sejin on 2023/10/28.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum NotificationLinkError: Error {
    case invalidLink
    case linkNotFound
    case expiredLink
    case invalidScheme
}
