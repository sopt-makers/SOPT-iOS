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
    
    func trackClickEmpty(
        sectionName: HomeAmplitudeEventPropertyValue,
        category: String
    ) {
        let properties = AmplitudeEventPropertyBuilder<HomeAmplitudeEventPropertyValue>()
            .add(key: .sectionName, value: sectionName)
            .add(key: .category, value: category)
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickEmpty, eventProperties: properties)
    }
 
    func trackClickPost(
        postRanking: Int? = 0, // NOTE: 최신 게시물일 경우, 랭킹이 존재하지 않고 0으로 처리합니다.
        sectionName: HomeAmplitudeEventPropertyValue,
        postID: Int? = 0,
        category: String
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
}
