//
//  HomePopularPostsModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 7/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomePopularPostModel {
    public let profileImage: String?
    public let name: String?
    public let generationAndPart: String?
    public let rank: Int
    public let category: String
    public let title: String
    public let content: String
    public let webLink: String
    public let id: Int?
    public let userId: Int?

    public init(
        profileImage: String?,
        name: String?,
        generationAndPart: String?,
        rank: Int,
        category: String,
        title: String,
        content: String,
        webLink: String,
        id: Int?,
        userId: Int?
    ) {
        self.profileImage = profileImage
        self.name = name
        self.generationAndPart = generationAndPart
        self.rank = rank
        self.category = category
        self.title = title
        self.content = content
        self.webLink = webLink
        self.id = id
        self.userId = userId
    }
}
