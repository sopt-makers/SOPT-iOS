//
//  HomeEventTracker.swift
//  HomeFeature
//
//  Created by Jae Hyun Lee on 9/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import HomeFeatureInterface

struct HomeEventTracker {
    func trackAmplitude(event: AmplitudeEventType?) {
        if let event {
            AmplitudeInstance.shared.trackWithUserType(event: event)
        }
    }
}
