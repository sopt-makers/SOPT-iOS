//
//  HomeCoordinatorDestination.swift
//  HomeFeatureInterface
//
//  Created by Jae Hyun Lee on 5/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public enum HomeCoordinatorDestination {
    case signIn
    case notification
    case attendance
    case mypage
    case calendar
    case appService(type: AppServiceType)

    case webLink(url: String)
    case deepLink(url: String)
}
