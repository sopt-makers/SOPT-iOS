//
//  SoptletterService.swift
//  Networks
//
//  Created by 강윤서 on 6/28/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Moya

public typealias DefaultSoptletterService = BaseService<SoptletterAPI>

public protocol SoptletterService {
    func writeMessage(topicId: Int, content: String) async throws
    func fetchTopics() async throws -> SoptletterTopicListEntity
    func fetchTopic(topicId: Int) async throws -> SoptletterTopicDetailEntity
}

extension DefaultSoptletterService: SoptletterService {
    public func writeMessage(topicId: Int, content: String) async throws {
        _ = try await requestObjectAsyncNoResult(.writeMessage(topicId: topicId, content: content))
    }
    
    public func fetchTopics() async throws -> SoptletterTopicListEntity {
        return try await requestObjectAsync(.fetchTopics)
    }
    
    public func fetchTopic(topicId: Int) async throws -> SoptletterTopicDetailEntity {
        return try await requestObjectAsync(.fetchTopic(topicId: topicId))
    }
}
