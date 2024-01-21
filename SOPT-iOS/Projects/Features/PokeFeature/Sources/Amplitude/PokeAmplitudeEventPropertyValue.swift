//
//  PokeAmplitudeEventPropertyValue.swift
//  PokeFeature
//
//  Created by sejin on 1/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Core

enum PokeAmplitudeEventPropertyValue: String, AmplitudeEventPropertyValueConvertible {
    case onboarding = "onboarding"
    case pokeMainAlarm = "poke_main_alarm"
    case pokeMainFriend = "poke_main_friend"
    case pokeMainRecommendNotMyFriend = "poke_main_recommend_notmyfriend"
    
    func toString() -> String {
        self.rawValue
    }
}
