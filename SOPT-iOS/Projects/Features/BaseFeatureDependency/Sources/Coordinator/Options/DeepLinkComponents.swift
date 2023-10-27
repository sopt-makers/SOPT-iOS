//
//  DeepLinkComponents.swift
//  BaseFeatureDependency
//
//  Created by sejin on 2023/10/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public class DeepLinkComponents {
    private var deeplinks: [Deeplinkable]
    public let queryItems: [URLQueryItem]?
    
    public var isEmpty: Bool {
        self.deeplinks.isEmpty
    }
    
    public init(deeplinkData: DeeplinkData) {
        self.deeplinks = deeplinkData.deeplinks
        self.queryItems = deeplinkData.queryItems
    }
    
    public func execute(coordinator: Coordinator) {
        guard let deeplink = popFirstDeeplink() else { return }
        deeplink.execute(with: coordinator, components: self)
    }
    
    public func addDeeplink(_ deeplink: Deeplinkable) {
        self.deeplinks.append(deeplink)
    }
    
    @discardableResult
    private func popFirstDeeplink() -> Deeplinkable? {
        if deeplinks.isEmpty { return nil }
        return deeplinks.removeFirst()
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
