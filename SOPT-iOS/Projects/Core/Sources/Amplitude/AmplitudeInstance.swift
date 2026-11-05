//
//  AmplitudeInstance.swift
//  Core
//
//  Created by sejin on 2023/09/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import AmplitudeSwift

public struct AmplitudeInstance {
    static public let shared = Amplitude(configuration: Configuration(apiKey: Config.Amplitude.apiKey))

    #if DEBUG
    /// 앱이 track한 이벤트를 디버깅 도구(Demo의 Necto 플러그인)에서 관찰하기 위한 클로저입니다.
    /// Amplitude 플러그인으로는 관찰할 수 없습니다.
    static public var onTrack: ((_ eventType: String, _ eventProperties: [String: Any]?) -> Void)?
    #endif

    private init() {}
}

public extension Amplitude {
    func track(eventType: AmplitudeEventType, eventProperties: [String: Any]? = nil) {
        let eventType: String = eventType.rawValue

        #if DEBUG
        AmplitudeInstance.onTrack?(eventType, eventProperties)
        #endif
        AmplitudeInstance.shared.track(eventType: eventType, eventProperties: eventProperties, options: nil)
    }

    func trackWithUserType(event: AmplitudeEventType, otherProperties: [String: Any]? = nil) {
        let eventType: String = event.rawValue
        let userType = UserDefaultKeyList.CoreAuth.getUserType()
        var eventProperties = otherProperties ?? [:]
        eventProperties[AmplitudeEventPropertyKey.viewType.rawValue] = userType.rawValue.lowercased()
        #if DEBUG
        AmplitudeInstance.onTrack?(eventType, eventProperties)
        #endif
        AmplitudeInstance.shared.track(eventType: eventType, eventProperties: eventProperties, options: nil)
    }
    
    func addPushNotificationAuthorizationIdentity(isAuthorized: Bool) {
        let identify = Identify()
        let key: AmplitudeUserPropertyKey = .stateOfPushNotification
        identify.set(property: key.rawValue, value: isAuthorized)
        
        AmplitudeInstance.shared.identify(identify: identify)
    }
}
