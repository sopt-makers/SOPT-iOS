//
//  HomeAmplitudeEventPropertyValue.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 9/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

enum HomeAmplitudeEventPropertyValue: String, AmplitudeEventPropertyValueConvertible {
    case latestPosts = "latest_posts"
    case popularPosts = "popular_posts"
    case realTimeFeed = "realtime_feed"
    case homeBanner = "home_banner"
    case homeFAB = "home_fab"
    case app = "app"
    case web = "web"

    func toString() -> String {
        self.rawValue
    }
}
