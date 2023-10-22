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

public struct DeepLinkParser {
    public func parse(with link: String) -> DeepLinkOption {
        guard let components = URLComponents(string: link) else {
            SentrySDK.capture(message: "푸시 알림 DeepLink Parse 에러: \(link)")
            return .deepLinkView(view: [DeepLinkViewKind.home], query: nil)
        }
        
        let pathComponents = components.path.split(separator: "/").map { String($0) }
        let queryItems = components.queryItems
        
        let viewList = makeViewList(with: pathComponents)
        
        return .deepLinkView(view: viewList, query: queryItems)
    }
    
    private func makeViewList(with pathComponents: [String]) -> [DeepLinkViewable] {
        var views = [DeepLinkViewable]()
        
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

