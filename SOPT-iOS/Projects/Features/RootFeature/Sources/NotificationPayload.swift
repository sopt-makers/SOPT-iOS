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
    let aps: APS
    
    public init?(dictionary: [AnyHashable: Any]) {
        do {
            self = try JSONDecoder().decode(NotificationPayload.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch {
            SentrySDK.capture(error: error)
            return nil
        }
    }
}

struct APS: Codable {
    let alert: Alert
    let category: String
    let deepLink: String?
    let webLink: String?
}

struct Alert: Codable {
    let body: String
    let title: String
}
