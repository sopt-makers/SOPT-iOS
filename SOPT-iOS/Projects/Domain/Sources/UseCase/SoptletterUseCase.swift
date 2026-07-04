//
//  SoptletterUseCase.swift
//  Domain
//
//  Created by 강윤서 on 6/28/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public protocol SoptletterUseCase {
    func writeMessage(topicId: Int, content: String) async throws
    func isWritable(content: String) -> Bool
    func fetchSoptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> SoptletterItemModel
    func fetchSoptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterDetailMessageModel
    func editMessage(messageId: Int, topicId: Int, content: String) async throws
    func deleteMessage(messageId: Int, topicId: Int) async throws
}

public final class DefaultSoptletterUseCase: SoptletterUseCase {
    
    private let repository: SoptletterRepositoryInterface
    private let maxCharCount = 250

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
    
    public func fetchSoptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> SoptletterItemModel {
        return try await repository.soptletterMessages(topicId: topicId, cursor: cursor, size: size)
    }
    
    public func fetchSoptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterDetailMessageModel {
        return try await repository.soptletterMessage(messageId: messageId, topicId: topicId)
    }
    
    public func editMessage(messageId: Int, topicId: Int, content: String) async throws {
        try await repository.editMessage(messageId: messageId, topicId: topicId, content: content)
    }
    
    public func deleteMessage(messageId: Int, topicId: Int) async throws {
        try await repository.deleteMessage(messageId: messageId, topicId: topicId)
    }
}
