//
//  WebLinkParser.swift
//  RootFeature
//
//  Created by sejin on 2023/11/13.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Sentry

struct WebLinkParser: NotificationLinkParser {
    func parse(with link: String) throws -> String {
        guard let components = URLComponents(string: link) else {
            SentrySDK.capture(message: "푸시 알림 WebLink Parse 에러: \(link)")
            throw NotificationLinkError.invalidLink
        }
        
        guard link.starts(with: "https") || link.starts(with: "http") else {
            throw NotificationLinkError.invalidScheme
        }
        
        let queryItems = components.queryItems
        
        if isExpiredLink(queryItems: queryItems) {
            throw NotificationLinkError.expiredLink
        }
        
        return link
    }
}
