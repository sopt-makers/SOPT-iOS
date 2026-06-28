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
        for try await _ in soptletterService.writeMessage(topicId: topicId, content: content).values { break }
    }
}
