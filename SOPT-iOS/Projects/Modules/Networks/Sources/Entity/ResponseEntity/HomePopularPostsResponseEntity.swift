//
//  HomePopularPostsResponseEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 7/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomePopularPostsResponseEntityWrapper: Decodable {
    public let popularPosts: [HomePopularPostsResponseEntity]
}

public struct HomePopularPostsResponseEntity: Decodable {
    public let profileImage: String?
    public let name: String?
    public let generationAndPart: String?
    public let rank: Int
    public let category: String
    public let title: String
    public let content: String
    public let webLink: String
    public let id: Int?
}
