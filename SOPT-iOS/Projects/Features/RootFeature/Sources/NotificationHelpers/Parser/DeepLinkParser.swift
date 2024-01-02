//
//  DeepLinkParser.swift
//  RootFeature
//
//  Created by sejin on 2023/10/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Core
import NotificationFeature

import Sentry

struct DeepLinkParser: NotificationLinkParser {
    private var defaultDeepLinks: [DeepLinkExecutable] {
        return [HomeDeepLink()]
    }
    
    func parse(with link: String) throws -> DeepLinkData {
        guard let components = URLComponents(string: link) else {
            SentrySDK.capture(message: "푸시 알림 DeepLink Parse 에러: \(link)")
            return (defaultDeepLinks, nil)
        }
        
        let pathComponents = components.path.split(separator: "/").map { String($0) }
        let queryItems = components.queryItems
        
        if isExpiredLink(queryItems: queryItems) {
            throw NotificationLinkError.expiredLink
        }
        
        let deepLinkList = try makeDeepLinkList(with: pathComponents)
        
        return (deepLinkList, queryItems)
    }
    
    private func makeDeepLinkList(with pathComponents: [String]) throws -> [DeepLinkExecutable] {
        var deepLinks = [DeepLinkExecutable]()
        
        for component in pathComponents {
            if deepLinks.isEmpty {
                guard let root = findRootDeepLink(name: component) else {
                    throw NotificationLinkError.linkNotFound
                }
                
                deepLinks.append(root)
                continue
            }
            
            guard let parent = deepLinks.last, let child = parent.findChild(name: component) else {
                throw NotificationLinkError.linkNotFound
            }
            
            deepLinks.append(child)
        }
        
        if !deepLinks.isEmpty {
            deepLinks[deepLinks.count-1].isDestination = true
        }
        
        return deepLinks
    }
    
    private func findRootDeepLink(name: String) -> DeepLinkExecutable? {
        switch name {
        case "home":
            return HomeDeepLink()
        default:
            return nil
        }
    }
}
