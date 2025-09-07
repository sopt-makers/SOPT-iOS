//
//  HomeLatestPostsTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 7/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomeLatestPostsResponseEntity {
    public func toDomain() -> HomeLatestPostModel {
        return HomeLatestPostModel(
            profileImage: self.profileImage,
            name: self.name,
            generationAndPart: self.generationAndPart,
            category: self.category,
            title: self.title,
            content: self.content,
            webLink: self.webLink,
            id: self.id,
            isOutdated: self.isOutdated,
            userId: self.userId
        )
    }
}
