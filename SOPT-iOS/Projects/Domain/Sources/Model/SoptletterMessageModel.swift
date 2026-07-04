//
//  SoptletterMessageModel.swift
//  Domain
//
//  Created by dev on 7/2/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

public struct SoptletterDetailMessageModel {
    public let messageId: Int
    public let topicId: Int
    public let authorNickname: String
    public let content: String
    public let colorCode: String
    public let rotationDegree: Int
    public let shapeType: String
    public let createdAt: String
    public let updatedAt: String
    public let likeCount: Int
    public let likedByMe: Bool
    public let mine: Bool
    
    public init(
        messageId: Int,
        topicId: Int,
        authorNickname: String,
        content: String,
        colorCode: String,
        rotationDegree: Int,
        shapeType: String,
        createdAt: String,
        updatedAt: String,
        likeCount: Int,
        likedByMe: Bool,
        mine: Bool
    ) {
        self.messageId = messageId
        self.topicId = topicId
        self.authorNickname = authorNickname
        self.content = content
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
