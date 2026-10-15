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
    
    func trackAppService(serviceType: AppServiceType) {
        switch serviceType {
        case .soptletter:
            AmplitudeInstance.shared.trackWithUserType(event: .clickSoptletterMenu)
        }
    }
    
    func trackPlaygroundCommunityBySection(kind: HomeForMemberSectionLayoutKind) {
        var sectionName = ""
        
        switch kind {
        case .mainProduct:
            sectionName = "playground_home"
        case .popularPosts:
            sectionName = "popular_posts"
        case .latestPosts:
            sectionName = "latest_posts"
        default:
            return
        }
        
        let properties = AmplitudeEventPropertyBuilder<HomeAmplitudeEventPropertyValue>()
            .add(key: "section_name", value: sectionName)
            .build()
        
        AmplitudeInstance.shared.trackWithUserType(event: .clickPlaygroundCommunity, otherProperties: properties)
    }
}
