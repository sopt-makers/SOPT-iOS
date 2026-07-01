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
    public func writeMessage(topicId: Int, content: String) async throws {
        try await soptletterService.writeMessage(topicId: topicId, content: content)
    }
    
    public func getSoptletterProfile() async throws -> SoptletterProfileModel{
        let result = try await soptletterService.getSoptletterProfile()
        return result.toDomain()
    }
    
    public func completeOnboarding() async throws {
        try await soptletterService.completeOnboarding()
    }
}
