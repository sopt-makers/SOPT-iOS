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
    func getSoptletterProfile() async throws
    func completeOnboarding() async throws
    
    var profileResult: CurrentValueSubject<SoptletterProfileModel, Never> { get }
}

public final class DefaultSoptletterUseCase: SoptletterUseCase {
    private let repository: SoptletterRepositoryInterface
    private let maxCharCount = 250
    
    public var profileResult = CurrentValueSubject<SoptletterProfileModel, Never>(.init(nickname: "", isOnboarded: false))

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
    
    public func getSoptletterProfile() async throws {
        let result = try await repository.getSoptletterProfile()
        profileResult.send(result)
    }
    
    public func completeOnboarding() async throws {
        try await repository.completeOnboarding()
    }
}
