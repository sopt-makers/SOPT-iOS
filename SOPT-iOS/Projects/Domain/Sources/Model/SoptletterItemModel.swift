//
//  SoptletterItemModel.swift
//  Domain
//
//  Created by dev on 7/1/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - Domain Model

public struct SoptletterItemModel {
    public let topicId: Int
    public let title: String
    public let totalCount: Int
    public let nextCursor: Int?
    public let hasNext: Bool
    public let messages: [SoptletterMessageModel]
    
    public init(topicId: Int, title: String, totalCount: Int, nextCursor: Int?, hasNext: Bool, messages: [SoptletterMessageModel]) {
        self.topicId = topicId
        self.title = title
        self.totalCount = totalCount
        self.nextCursor = nextCursor
        self.hasNext = hasNext
        self.messages = messages
    }
}

public struct SoptletterMessageModel {
    public let messageId: Int
    public let authorNickname: String
    public let previewContent: String
    public let colorCode: String
    public let rotationDegree: Int
    public let shapeType: String
    public let createdAt: String
    public let updatedAt: String
    public let likeCount: Int
    public let likedByMe: Bool
    public let mine: Bool
    
    public init(messageId: Int, authorNickname: String, previewContent: String, colorCode: String, rotationDegree: Int, shapeType: String, createdAt: String, updatedAt: String, likeCount: Int, likedByMe: Bool, mine: Bool) {
        self.messageId = messageId
        self.authorNickname = authorNickname
        self.previewContent = previewContent
        self.colorCode = colorCode
        self.rotationDegree = rotationDegree
        self.shapeType = shapeType
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.likeCount = likeCount
        self.likedByMe = likedByMe
        self.mine = mine
    }
}
