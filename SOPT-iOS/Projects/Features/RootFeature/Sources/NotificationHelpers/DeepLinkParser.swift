//
//  DeepLinkParser.swift
//  RootFeature
//
//  Created by sejin on 2023/10/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Sentry

typealias DeepLinkURLData = (views: [DeepLinkViewKind], queryItems: [URLQueryItem]?)

struct DeepLinkParser {
    func parse(with link: String) -> DeepLinkURLData {
        guard let components = URLComponents(string: link) else {
            SentrySDK.capture(message: "푸시 알림 DeepLink Parse 에러: \(link)")
            return ([DeepLinkViewKind.home], nil)
        }
        
        let pathComponents = components.path.split(separator: "/").map { String($0) }
        let queryItems = components.queryItems
        
        let viewList = makeViewList(with: pathComponents)
        
        return (viewList, queryItems)
    }
    
    private func makeViewList(with pathComponents: [String]) -> [DeepLinkViewKind] {
        var views = [DeepLinkViewKind]()
        
        for component in pathComponents {
            if views.isEmpty {
                guard let root = DeepLinkViewKind.findRoot(name: component) else { return [DeepLinkViewKind.home] }
                views.append(root)
                continue
            }
            
            if let lastView = views.last {
                guard let nextView = lastView.findChild(name: component) else { return views }
                views.append(nextView)
            }
        }
        
        return views
    }
}

