//
//  SoptletterTransform.swift
//  Data
//
//  Created by dev on 7/1/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

// MARK: - Mapper (Entity -> Domain)

extension SoptletterItemResponseEntity {
    func toDomain() -> SoptletterItemModel {
        return SoptletterItemModel(
            topicId: topicId,
            title: title,
            totalCount: totalCount,
            nextCursor: nextCursor,
            hasNext: hasNext,
            messages: messages.map { $0.toDomain() }
        )
    }
}

extension SoptletterMessageResponseEntity {
    func toDomain() -> SoptletterDetailMessageModel {
        return SoptletterDetailMessageModel(
            messageId: messageId,
            topicId: topicId,
            authorNickname: authorNickname,
            content: content,
            colorCode: colorCode,
            rotationDegree: rotationDegree,
            shapeType: shapeType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            likeCount: likeCount,
            likedByMe: likedByMe,
            mine: mine
        )
    }
}

extension SoptletterMessageEntity {
    func toDomain() -> SoptletterMessageModel {
        return SoptletterMessageModel(
            messageId: messageId,
            authorNickname: authorNickname,
            previewContent: previewContent,
            colorCode: colorCode,
            rotationDegree: rotationDegree,
            shapeType: shapeType,
            createdAt: createdAt,
            updatedAt: updatedAt,
            likeCount: likeCount,
            likedByMe: likedByMe,
            mine: mine
        )
    }
}
