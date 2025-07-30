//
//  HomeLatestPostsResponseEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 7/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeLatestPostsResponseEntityWrapper: Decodable {
    public let recentPosts: [HomeLatestPostsResponseEntity]
}

public struct HomeLatestPostsResponseEntity: Decodable {
    public let profileImage: String?
    public let name: String
    public let generationAndPart: String
    public let category: String
    public let title: String
    public let content: String
    public let webLink: String
    public let id: Int
    public let isOutdated: Bool
}
