//
//  NotificationLinkParser.swift
//  RootFeature
//
//  Created by sejin on 2023/11/13.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
 
protocol NotificationLinkParser {
    func isExpiredLink(queryItems: [URLQueryItem]?) -> Bool
}

extension NotificationLinkParser {
    func isExpiredLink(queryItems: [URLQueryItem]?) -> Bool {
        guard let expiredAt = queryItems?.getQueryValue(key: "expiredAt") else {
            return false
        }
        
        return expiredAt.toDate() < Date.now
    }
}
