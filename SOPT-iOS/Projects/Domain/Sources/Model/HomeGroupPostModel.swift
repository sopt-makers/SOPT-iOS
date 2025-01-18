//
//  HomeGroupPostModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Networks

public struct HomeGroupPostModel: Codable {
    public let id: Int
    public let title: String
    public let category: String
    public let canJoinOnlyActiveGeneration: Bool
    public let joinableParts: [String]
    public let canJoinAllParts: Bool
    public let status: HomeGroupEntity.Status
    public let imageUrl: String
    
    public init(id: Int, title: String, category: String, canJoinOnlyActiveGeneration: Bool, joinableParts: [String], canJoinAllParts: Bool, status: HomeGroupEntity.Status, imageUrl: String) {
        self.id = id
        self.title = title
        self.category = category
        self.canJoinOnlyActiveGeneration = canJoinOnlyActiveGeneration
        self.joinableParts = joinableParts
        self.canJoinAllParts = canJoinAllParts
        self.status = status
        self.imageUrl = imageUrl
    }
}
