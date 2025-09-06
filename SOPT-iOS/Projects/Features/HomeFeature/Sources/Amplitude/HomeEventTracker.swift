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
    
    func trackClickPostMember(
        postRanking: Int,
        sectionName: HomeAmplitudeEventPropertyValue,
        postID: Int,
        category: Int
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
    
    func trackClickPost(
        postRanking: Int,
        sectionName: HomeAmplitudeEventPropertyValue,
        postID: Int,
        category: Int
    ) {
        let properties = AmplitudeEventPropertyBuilder<HomeAmplitudeEventPropertyValue>()
            .add(key: .postRanking, value: postRanking)
            .add(key: .sectionName, value: sectionName)
            .add(key: .postID, value: postID)
            .add(key: .category, value: category)
            .addViewType()
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickPost, eventProperties: properties)
    }
    
    func trackClickEmpty(
        sectionName: HomeAmplitudeEventPropertyValue,
        category: Int
    ) {
        let properties = AmplitudeEventPropertyBuilder<HomeAmplitudeEventPropertyValue>()
            .add(key: .sectionName, value: sectionName)
            .add(key: .category, value: category)
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickEmpty, eventProperties: properties)
    }
    
    func trackClickViewAll(
        sectionName: HomeAmplitudeEventPropertyValue
    ) {
        let properties = AmplitudeEventPropertyBuilder<HomeAmplitudeEventPropertyValue>()
            .add(key: .sectionName, value: sectionName)
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickViewAll, eventProperties: properties)
    }
    
}
