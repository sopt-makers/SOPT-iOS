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
import Domain

struct PokeEventTracker {
    func trackViewEvent(with viewEvent: AmplitudeEventType) {
        AmplitudeInstance.shared.trackWithUserType(event: viewEvent)
    }
    
    func trackSendMessageEvent(isAnonymous: Bool, message: PokeMessageModel) {
        AmplitudeInstance.shared.track(eventType: .clickPokeSendMessage, eventProperties: [
            "message_type": "poke",
            "message_id": message.messageId,
            "is_anonymous": isAnonymous
        ])
        
        if isAnonymous {
            AmplitudeInstance.shared.track(eventType: .clickPokeAnonymity, eventProperties: [
                "message_type": "poke",
                "is_anonymous": isAnonymous
            ])
        }
    }
    
    func trackViewFriendsListEvent(friendType: PokeRelation) {
        let properties = AmplitudeEventPropertyBuilder<PokeAmplitudeEventPropertyValue>()
            .addViewType()
            .add(key: .friendType, value: friendType.toEnglishName)
            .build()
        
        AmplitudeInstance.shared.track(eventType: .viewPokeFriendDetail, eventProperties: properties)
    }
    
    func trackClickPokeEvent(clickView: PokeAmplitudeEventPropertyValue, userId: Int? = nil) {
        let properties = AmplitudeEventPropertyBuilder<PokeAmplitudeEventPropertyValue>()
            .addViewType()
            .add(key: .clickViewType, value: clickView)
            .add(key: .viewProfile, value: userId)
            .removeOptional()
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickPokeIcon, eventProperties: properties)
    }
    
    func trackClickMemberProfileEvent(clickView: PokeAmplitudeEventPropertyValue, userId: Int? = nil) {
        let properties = AmplitudeEventPropertyBuilder<PokeAmplitudeEventPropertyValue>()
            .addViewType()
            .add(key: .clickViewType, value: clickView)
            .add(key: .viewProfile, value: userId)
            .removeOptional()
            .build()
        
        AmplitudeInstance.shared.track(eventType: .clickMemberProfile, eventProperties: properties)
    }
}
