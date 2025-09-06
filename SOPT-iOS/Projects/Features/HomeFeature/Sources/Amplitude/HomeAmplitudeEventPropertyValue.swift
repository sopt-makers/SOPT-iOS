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
    case realTimeFeed = "realtime_feed"

    func toString() -> String {
        self.rawValue
    }
}
