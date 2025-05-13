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
    case setting(userType: UserType)
    case attendance
    case soptlog
    case calendar
    case poke(isNewUser: Bool)
    
    case webLink(url: String)
    case deepLink(url: String)
}
