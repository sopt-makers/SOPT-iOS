//
//  AmplitudeEventPropertyBuilder.swift
//  Core
//
//  Created by sejin on 1/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public class AmplitudeEventPropertyBuilder {
    private var eventProperties = [String: Any]()
    
    public init() {}
    
    public func add(key: String, value: Any) -> Self {
        self.eventProperties[key] = value
        return self
    }
    
    public func add(key: AmplitudeEventPropertyKey, value: AmplitudeEventPropertyValueConvertible) -> Self {
        self.eventProperties[key.rawValue] = value.toString()
        return self
    }
    
    public func build() -> [String: Any] {
        return eventProperties
    }
}
