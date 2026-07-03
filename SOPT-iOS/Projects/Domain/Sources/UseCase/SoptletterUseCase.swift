//
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
    func getSoptletterProfile() async throws -> SoptletterProfileModel
    func completeOnboarding() async throws
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
    
    public func getSoptletterProfile() async throws -> SoptletterProfileModel {
        return try await repository.getSoptletterProfile()
    }
    
    public func completeOnboarding() async throws {
        try await repository.completeOnboarding()
        UserDefaultKeyList.User.isCompleteSoptletterOnboarding = true
    }
}
