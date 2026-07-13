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
    func getSoptletterProfile() async throws -> SoptletterOnboardingEntity
    func completeOnboarding() async throws
    func soptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> SoptletterItemResponseEntity
    func soptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterMessageResponseEntity
    func editMessage(messageId: Int, topicId: Int, content: String) async throws
    func deleteMessage(messageId: Int, topicId: Int) async throws
    func likeMessage(messageId: Int, topicId: Int) async throws
    func unlikeMessage(messageId: Int, topicId: Int) async throws
    func fetchCTA() async throws -> SoptletterCTAResponse
    func fetchDefaultTopic() async throws -> SoptletterItemResponseEntity
}

extension DefaultSoptletterService: SoptletterService {
    public func fetchDefaultTopic() async throws -> SoptletterItemResponseEntity {
        return try await requestObjectAsync(.fetchDefaultTopic)
    }
    
    public func fetchCTA() async throws -> SoptletterCTAResponse {
        return try await requestObjectAsync(.fetchCTA)
    }
    
    public func likeMessage(messageId: Int, topicId: Int) async throws {
        _ = try await requestObjectAsyncNoResult(.likeMessage(messageId: messageId, topicId: topicId))
    }
    
    public func unlikeMessage(messageId: Int, topicId: Int) async throws {
        _ = try await requestObjectAsyncNoResult(.unlikeMessage(messageId: messageId, topicId: topicId))
    }
    
    public func soptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> SoptletterItemResponseEntity {
        return try await requestObjectAsync(.soptletterMessages(topicId: topicId, cursor: cursor, size: size))
    }
    
    public func writeMessage(topicId: Int, content: String) async throws {
        _ = try await requestObjectAsyncNoResult(.writeMessage(topicId: topicId, content: content))
    }
    
    public func fetchTopics() async throws -> SoptletterTopicListEntity {
        return try await requestObjectAsync(.fetchTopics)
    }
    
    public func fetchTopic(topicId: Int) async throws -> SoptletterTopicDetailEntity {
        return try await requestObjectAsync(.fetchTopic(topicId: topicId))
    }
    
    public func getSoptletterProfile() async throws -> SoptletterOnboardingEntity {
        return try await requestObjectAsync(.fetchProfile)
    }
    
    public func completeOnboarding() async throws {
       _ = try await requestObjectAsyncNoResult(.completeOnboarding)
    }
    
    public func soptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterMessageResponseEntity {
        return try await requestObjectAsync(.soptletterMessage(messageId: messageId, topicId: topicId))
    }
    
    public func editMessage(messageId: Int, topicId: Int, content: String) async throws {
        _ = try await requestObjectAsyncNoResult(.editMessage(messageId: messageId, topicId: topicId, content: content))
    }
    
    public func deleteMessage(messageId: Int, topicId: Int) async throws {
        _ = try await requestObjectAsyncNoResult(.deleteMessage(messageId: messageId, topicId: topicId))
    }
}
