//
//  DeepLinkComponents.swift
//  BaseFeatureDependency
//
//  Created by sejin on 2023/10/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public class DeepLinkComponents {
    private var deepLinks: [DeepLinkable]
    public let queryItems: [URLQueryItem]?
    
    public var isEmpty: Bool {
        self.deepLinks.isEmpty
    }
    
    public init(deepLinkData: DeepLinkData) {
        self.deepLinks = deepLinkData.deepLinks
        self.queryItems = deepLinkData.queryItems
    }
    
    public func execute(coordinator: Coordinator) {
        guard let deeplink = popFirstDeepLink() else { return }
        deeplink.execute(with: coordinator, components: self)
    }
    
    public func addDeepLink(_ deepLink: DeepLinkable) {
        self.deepLinks.append(deepLink)
    }
    
    @discardableResult
    private func popFirstDeepLink() -> DeepLinkable? {
        if deepLinks.isEmpty { return nil }
        return deepLinks.removeFirst()
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
