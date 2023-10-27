//
//  DeepLinkParser.swift
//  RootFeature
//
//  Created by sejin on 2023/10/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import NotificationFeature

import Sentry

struct DeepLinkParser {
    private var defaultDeepLinks: [DeepLinkable] {
        return [HomeDeepLink()]
    }
    
    func parse(with link: String) -> DeepLinkData {
        guard let components = URLComponents(string: link) else {
            SentrySDK.capture(message: "푸시 알림 DeepLink Parse 에러: \(link)")
            return (defaultDeepLinks, nil)
        }
        
        let pathComponents = components.path.split(separator: "/").map { String($0) }
        let queryItems = components.queryItems
        
        let deepLinkList = makeDeepLinkList(with: pathComponents)
        
        return (deepLinkList, queryItems)
    }
    
    private func makeDeepLinkList(with pathComponents: [String]) -> [DeepLinkable] {
        var deepLinks = [DeepLinkable]()
        
        for component in pathComponents {
            switch component {
            case "home":
                deepLinks.append(HomeDeepLink())
            case "notification":
                deepLinks.append(NotificationDeepLink())
            case "detail":
                deepLinks.append(NotificationDetailDeepLink())
            default:
                break
            }
        }
        
        return deepLinks
    }
}

