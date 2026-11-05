//
//  SoptletterDeepLink.swift
//  RootFeature
//
//  Created by 이나연 on 10/15/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency
import SoptletterFeature

public struct SoptletterDeepLink: DeepLinkExecutable {
    public let name = "soptletter"
    public let children: [DeepLinkExecutable] = [SoptletterTopicDeepLink()]
    public var isDestination: Bool = false
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }
        
        let soptletterCoordinator = coordinator.makeSoptletterCoordinator()
        
        if isDestination {
            if let topicId = queryItems?.first(where: { $0.name == "topicId" })?.value.flatMap(Int.init),
               let messageId = queryItems?.first(where: { $0.name == "messageId" })?.value.flatMap(Int.init) {
                soptletterCoordinator.startWithMessageDetail(topicId: topicId, messageId: messageId)
            } else {
                soptletterCoordinator.start()
            }
        }
        
        return soptletterCoordinator
    }
}
