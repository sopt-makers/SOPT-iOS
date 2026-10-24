//
//  SoptletterTopicDeepLink.swift
//  SoptletterFeature
//
//  Created by 이나연 on 10/15/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency

public struct SoptletterTopicDeepLink: DeepLinkExecutable {
    public let name = "topic"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = true
    
    public init() {}
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? SoptletterCoordinator else { return nil }
        coordinator.start()
        return coordinator
    }
}
