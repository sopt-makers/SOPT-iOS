//
//  SoptletterRepository.swift
//  Data
//
//  Created by 강윤서 on 6/28/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Core
import Domain
import Networks

public final class SoptletterRepository {
    private let soptletterService: SoptletterService

    public init(soptletterService: SoptletterService) {
        self.soptletterService = soptletterService
    }
}

extension SoptletterRepository: SoptletterRepositoryInterface {
    public func editMessage(messageId: Int, topicId: Int, content: String) async throws {
        try await soptletterService.editMessage(messageId: messageId, topicId: topicId, content: content)
    }
    
    public func deleteMessage(messageId: Int, topicId: Int) async throws {
        try await soptletterService.deleteMessage(messageId: messageId, topicId: topicId)
    }
    
    public func soptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> Domain.SoptletterItemModel {
        return try await soptletterService.soptletterMessages(topicId: topicId, cursor: cursor, size: size).toDomain()
    }
    
    public func writeMessage(topicId: Int, content: String) async throws {
        try await soptletterService.writeMessage(topicId: topicId, content: content)
    }
    
    public func fetchTopics() async throws -> SoptletterTopicListModel {
        return try await soptletterService.fetchTopics().toDomain()
    }
    
    public func fetchTopic(topicId: Int) async throws -> SoptletterTopicDetailModel {
        return try await soptletterService.fetchTopic(topicId: topicId).toDomain()
    }
    
    public func getSoptletterProfile() async throws -> SoptletterProfileModel{
        let result = try await soptletterService.getSoptletterProfile()
        return result.toDomain()
    }
    
    public func completeOnboarding() async throws {
        try await soptletterService.completeOnboarding()
    }
    
    public func soptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterDetailMessageModel {
        return try await soptletterService.soptletterMessage(messageId: messageId, topicId: topicId).toDomain()
    }
}
