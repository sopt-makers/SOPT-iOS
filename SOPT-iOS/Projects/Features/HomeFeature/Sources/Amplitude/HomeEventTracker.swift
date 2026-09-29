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
    
    func trackClickPostMember(
        postRanking: Int?,
        sectionName: HomeAmplitudeEventPropertyValue,
        postID: Int?,
        category: String
    ) {
        let properties = AmplitudeEventPropertyBuilder<HomeAmplitudeEventPropertyValue>()
            .add(key: .postRanking, value: postRanking)
            .add(key: .sectionName, value: sectionName)
            .add(key: .postID, value: postID)
            .add(key: .category, value: category)
            .addViewType()
            .build()
            
        AmplitudeInstance.shared.track(eventType: .clickPostMember, eventProperties: properties)
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
