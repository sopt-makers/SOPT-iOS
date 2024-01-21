//
//  PokeEventTracker.swift
//  PokeFeature
//
//  Created by sejin on 1/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Core
import PokeFeatureInterface

struct PokeEventTracker {
    func trackViewEvent(with viewEvent: AmplitudeEventType) {
        AmplitudeInstance.shared.trackWithUserType(event: viewEvent)
    }
    
    func trackViewFriendsListEvent(friendType: PokeRelation) {
        let properties = AmplitudeEventPropertyBuilder<PokeAmplitudeEventPropertyValue>()
            .addViewType()
            .add(key: .friendType, value: friendType.toEnglishName)
            .build()
        
        AmplitudeInstance.shared.track(eventType: .viewPokeFriendDetail, eventProperties: properties)
    }
        
    func trackClickPokeEvent(clickView: PokeAmplitudeEventPropertyValue, playgroundId: Int? = nil) {
        let properties = AmplitudeEventPropertyBuilder<PokeAmplitudeEventPropertyValue>()
            .addViewType()
            .add(key: .clickViewType, value: clickView)
            .add(key: .viewProfile, value: playgroundId)
            .removeOptional()
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickPokeIcon, eventProperties: properties)
    }

    func trackClickMemberProfileEvent(clickView: PokeAmplitudeEventPropertyValue, playgroundId: Int? = nil) {
        let properties = AmplitudeEventPropertyBuilder<PokeAmplitudeEventPropertyValue>()
            .addViewType()
            .add(key: .clickViewType, value: clickView)
            .add(key: .viewProfile, value: playgroundId)
            .removeOptional()
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickMemberProfile, eventProperties: properties)
    }
}
