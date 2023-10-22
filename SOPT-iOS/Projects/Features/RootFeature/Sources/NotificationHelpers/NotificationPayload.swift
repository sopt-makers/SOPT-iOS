//
//  NotificationPayload.swift
//  RootFeature
//
//  Created by sejin on 2023/10/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Sentry

public struct NotificationPayload: Codable {
    public let aps: APS
    
    public var hasLink: Bool {
        self.hasWebLink || self.hasDeepLink
    }
    
    public var hasWebLink: Bool {
        guard let webLink = aps.webLink, !webLink.isEmpty else {
            return false
        }
        return true
    }
    
    public var hasDeepLink: Bool {
        guard let deepLink = aps.deepLink, !deepLink.isEmpty else {
            return false
        }
        return true
    }
    
    public init?(dictionary: [AnyHashable: Any]) {
        do {
            self = try JSONDecoder().decode(NotificationPayload.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch {
            SentrySDK.capture(error: error)
            return nil
        }
    }
}

public struct APS: Codable {
    public let alert: Alert
    public let category: String
    public let deepLink: String?
    public let webLink: String?
}

public struct Alert: Codable {
    public let body: String
    public let title: String
}
