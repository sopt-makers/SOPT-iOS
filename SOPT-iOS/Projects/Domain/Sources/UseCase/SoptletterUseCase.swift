//  SoptletterUseCase.swift
//  Domain
//
//  Created by 강윤서 on 6/28/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//
import Combine
import Core

public protocol SoptletterUseCase {
    func writeMessage(topicId: Int, content: String) async throws
    func isWritable(content: String) -> Bool
    func fetchTopics() async throws -> SoptletterTopicListModel
    func fetchTopic(topicId: Int) async throws -> SoptletterTopicDetailModel
    func getSoptletterProfile() async throws -> SoptletterProfileModel
    func completeOnboarding() async throws
    func fetchSoptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> SoptletterItemModel
    func fetchSoptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterDetailMessageModel
    func editMessage(messageId: Int, topicId: Int, content: String) async throws
    func deleteMessage(messageId: Int, topicId: Int) async throws
    func likeMessage(messageId: Int, topicId: Int) async throws
    func unlikeMessage(messageId: Int, topicId: Int) async throws
    func fetchCTA() async throws -> SoptletterCTAModel
}

public final class DefaultSoptletterUseCase: SoptletterUseCase {

    private let repository: SoptletterRepositoryInterface
    private let maxCharCount = 350
    
    public var topicsResult = PassthroughSubject<SoptletterTopicListModel, Never>()
    public var selectedTopicResult = PassthroughSubject<SoptletterTopicDetailModel, Never>()
    
    public init(repository: SoptletterRepositoryInterface) {
        self.repository = repository
    }
    
    public func writeMessage(topicId: Int, content: String) async throws {
        guard isWritable(content: content) else {
            throw SoptletterError.invalidContent
        }
        try await repository.writeMessage(topicId: topicId, content: content)
    }
    
    public func isWritable(content: String) -> Bool {
        return !content.isEmpty && content.count <= maxCharCount
    }
    
    public func fetchTopics() async throws -> SoptletterTopicListModel {
        return try await repository.fetchTopics()
    }
    
    public func fetchTopic(topicId: Int) async throws -> SoptletterTopicDetailModel {
        return try await repository.fetchTopic(topicId: topicId)
    }
    
    public func getSoptletterProfile() async throws -> SoptletterProfileModel {
        return try await repository.getSoptletterProfile()
    }
    
    public func completeOnboarding() async throws {
        try await repository.completeOnboarding()
        UserDefaultKeyList.User.isCompleteSoptletterOnboarding = true
    }
    
    public func fetchSoptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> SoptletterItemModel {
        return try await repository.soptletterMessages(topicId: topicId, cursor: cursor, size: size)
    }
    
    public func fetchSoptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterDetailMessageModel {
        return try await repository.soptletterMessage(messageId: messageId, topicId: topicId)
    }
    
    public func editMessage(messageId: Int, topicId: Int, content: String) async throws {
        guard isWritable(content: content) else {
            throw SoptletterError.invalidContent
        }
        try await repository.editMessage(messageId: messageId, topicId: topicId, content: content)
    }
    
    public func deleteMessage(messageId: Int, topicId: Int) async throws {
        try await repository.deleteMessage(messageId: messageId, topicId: topicId)
    }
    
    public func likeMessage(messageId: Int, topicId: Int) async throws {
        try await repository.likeMessage(messageId: messageId, topicId: topicId)
    }
    
    public func unlikeMessage(messageId: Int, topicId: Int) async throws {
        try await repository.unlikeMessage(messageId: messageId, topicId: topicId)
    }
    
    public func fetchCTA() async throws -> SoptletterCTAModel {
        return try await repository.fetchCTA()
    }
}
