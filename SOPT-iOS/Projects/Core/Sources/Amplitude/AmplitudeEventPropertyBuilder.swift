//
//  AmplitudeEventPropertyBuilder.swift
//  Core
//
//  Created by sejin on 1/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public class AmplitudeEventPropertyBuilder<Value: AmplitudeEventPropertyValueConvertible> {
    private var eventProperties = [String: Any]()
    
    public init() {}
    
    /// ViewType 은 UserType과 같다.
    public func addViewType() -> Self {
        let key: AmplitudeEventPropertyKey = .viewType
        let userType = UserDefaultKeyList.Auth.getUserType()
        let value = userType.rawValue.lowercased()
        self.eventProperties[key.rawValue] = value
        return self
    }
    
    public func add(key: String, value: Any) -> Self {
        self.eventProperties[key] = value
        return self
    }
    
    public func add(key: AmplitudeEventPropertyKey, value: Any) -> Self {
        self.eventProperties[key.rawValue] = value
        return self
    }
    
    public func add(key: AmplitudeEventPropertyKey, value: Optional<Any>) -> Self {
        self.eventProperties[key.rawValue] = value
        return self
    }
    
    public func add(key: AmplitudeEventPropertyKey, value: Value) -> Self {
        self.eventProperties[key.rawValue] = value.toString()
        return self
    }
    
    public func removeOptional() -> Self {
        self.eventProperties = self.eventProperties.compactMapValues { $0 }
        return self
    }
    
    public func build() -> [String: Any] {
        return eventProperties
    }
}
