//
//  DeepLinkComponents.swift
//  RootFeature
//
//  Created by sejin on 2023/10/28.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency

public class DeepLinkComponents: DeepLinkComponentsExecutable {
    private var deepLinks: [DeepLinkExecutable]
    public let queryItems: [URLQueryItem]?
    
    public var isEmpty: Bool {
        self.deepLinks.isEmpty
    }
    
    public init(deepLinkData: DeepLinkData) {
        self.deepLinks = deepLinkData.deepLinks
        self.queryItems = deepLinkData.queryItems
    }
    
    public convenience init?(deepLinkData: DeepLinkData?) {
        guard let deepLinkData = deepLinkData else {
            return nil
        }
        self.init(deepLinkData: deepLinkData)
    }
    
    // deepLink 배열을 재귀적으로 돌며 각 단계의 딥링크 뷰로 이동시킨다.
    public func execute(coordinator: Coordinator) {
        var nextCoordinator: Coordinator? = coordinator
        while !self.isEmpty, let coordinator = nextCoordinator {
            let deepLink = popFirstDeepLink()
            nextCoordinator = deepLink?.execute(with: coordinator, queryItems: self.queryItems)
        }
    }
    
    public func addDeepLink(_ deepLink: DeepLinkExecutable) {
        self.deepLinks.append(deepLink)
    }
    
    @discardableResult
    private func popFirstDeepLink() -> DeepLinkExecutable? {
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
