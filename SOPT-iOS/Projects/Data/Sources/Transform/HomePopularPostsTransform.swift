//
//  HomePopularPostsTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 7/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomePopularPostsResponseEntity {
    public func toDomain() -> HomePopularPostModel {
        return HomePopularPostModel(
            profileImage: self.profileImage,
            name: self.name,
            generationAndPart: self.generationAndPart,
            rank: self.rank,
            category: self.category,
            title: self.title,
            content: self.content,
            webLink: self.webLink,
            id: self.id,
            userId: self.userId
        )
    }
}
