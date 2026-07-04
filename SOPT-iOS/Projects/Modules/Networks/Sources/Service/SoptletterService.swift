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
<<<<<<< HEAD
    func getSoptletterProfile() async throws -> SoptletterOnboardingEntity
    func completeOnboarding() async throws
=======
    func soptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> SoptletterItemResponseEntity
    func soptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterMessageResponseEntity
>>>>>>> develop
}

extension DefaultSoptletterService: SoptletterService {
    public func soptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> SoptletterItemResponseEntity {
        return try await requestObjectAsync(.soptletterMessages(topicId: topicId, cursor: cursor, size: size))
    }
    
    public func writeMessage(topicId: Int, content: String) async throws {
        _ = try await requestObjectAsyncNoResult(.writeMessage(topicId: topicId, content: content))
    }
    
<<<<<<< HEAD
    public func getSoptletterProfile() async throws -> SoptletterOnboardingEntity {
        return try await requestObjectAsync(.fetchProfile)
    }
    
    public func completeOnboarding() async throws {
       _ = try await requestObjectAsyncNoResult(.completeOnboarding)
=======
    public func soptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterMessageResponseEntity {
        return try await requestObjectAsync(.soptletterMessage(messageId: messageId, topicId: topicId))
>>>>>>> develop
    }
}
