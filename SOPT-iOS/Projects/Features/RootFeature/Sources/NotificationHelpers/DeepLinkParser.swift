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
    private var defaultDeeplinks: [Deeplinkable] {
        return [HomeDeeplink()]
    }
    
    func parse(with link: String) -> DeeplinkData {
        guard let components = URLComponents(string: link) else {
            SentrySDK.capture(message: "푸시 알림 DeepLink Parse 에러: \(link)")
            return (defaultDeeplinks, nil)
        }
        
        let pathComponents = components.path.split(separator: "/").map { String($0) }
        let queryItems = components.queryItems
        
        let deeplinkList = makeDeeplinkList(with: pathComponents)
        
        return (deeplinkList, queryItems)
    }
    
    private func makeDeeplinkList(with pathComponents: [String]) -> [Deeplinkable] {
        var deeplinks = [Deeplinkable]()
        
        for component in pathComponents {
            switch component {
            case "home":
                deeplinks.append(HomeDeeplink())
            case "notification":
                deeplinks.append(NotificationDeeplink())
            case "detail":
                deeplinks.append(NotificationDetailDeeplink())
            default:
                break
            }
        }
        
        return deeplinks
    }
}

