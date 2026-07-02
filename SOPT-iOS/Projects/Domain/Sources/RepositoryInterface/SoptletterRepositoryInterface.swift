//
//  SoptletterRepositoryInterface.swift
//  Domain
//
//  Created by 강윤서 on 6/28/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public protocol SoptletterRepositoryInterface {
    func writeMessage(topicId: Int, content: String) async throws
    func soptletterMessages(topicId: Int, cursor: Int?, size: Int?) async throws -> SoptletterItemModel
    func soptletterMessage(messageId: Int, topicId: Int) async throws -> SoptletterDetailMessageModel
}
