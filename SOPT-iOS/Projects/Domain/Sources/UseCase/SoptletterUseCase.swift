//
//  SoptletterUseCase.swift
//  Domain
//
//  Created by 강윤서 on 6/28/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Combine

public protocol SoptletterUseCase {
    func writeMessage(topicId: Int, content: String) async throws
    func isWritable(content: String) -> Bool
    func fetchTopics() async throws
    func fetchTopic(topicId: Int) async throws
    
    var topicsResult: PassthroughSubject<SoptletterTopicListModel, Never> { get }
    var selectedTopicResult: PassthroughSubject<SoptletterTopicDetailModel, Never> { get }
}

public final class DefaultSoptletterUseCase: SoptletterUseCase {
    private let repository: SoptletterRepositoryInterface
    private let maxCharCount = 250
    
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
    
    public func fetchTopics() async throws {
        let result = try await repository.fetchTopics()
        topicsResult.send(result)
    }
    
    public func fetchTopic(topicId: Int) async throws {
        let result = try await repository.fetchTopic(topicId: topicId)
        selectedTopicResult.send(result)
    }
}
