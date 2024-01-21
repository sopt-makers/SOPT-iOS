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
    
    func toString() -> String {
        self.rawValue
    }
}
