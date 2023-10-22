//
//  DeepLinkComponents.swift
//  BaseFeatureDependency
//
//  Created by sejin on 2023/10/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public class DeepLinkComponents {
    public var views: [DeepLinkViewKind]
    public let queryItems: [URLQueryItem]?
    
    public var isEmpty: Bool {
        self.views.isEmpty
    }
    
    public init(views: [DeepLinkViewKind], queryItems: [URLQueryItem]? = nil) {
        self.views = views
        self.queryItems = queryItems
    }
    
    public func addView(_ viewKind: DeepLinkViewKind) {
        self.views.append(viewKind)
    }
    
    @discardableResult
    public func popFirstView() -> DeepLinkViewKind? {
        if views.isEmpty { return nil }
        return views.removeFirst()
    }
    
    public func getQueryItemValue(name: String) -> String? {
        guard let queryItems else { return nil }
        
        for item in queryItems {
            if item.name == name {
                return item.value
            }
        }
        
        return nil
    }
}
