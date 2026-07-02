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
    public func soptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> Domain.SoptletterItemModel {
        return try await soptletterService.soptletterMessages(topicId: topicId, cursor: cursor, size: size).toDomain()
    }
    
    public func writeMessage(topicId: Int, content: String) async throws {
        try await soptletterService.writeMessage(topicId: topicId, content: content)
    }
}
