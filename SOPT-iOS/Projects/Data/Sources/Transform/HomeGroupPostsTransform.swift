//
//  HomeGroupPostsTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomeGroupEntity {
    public func toDomain() -> HomeGroupPostModel {
        return HomeGroupPostModel(id: id, title: title, category: category, canJoinOnlyActiveGeneration: canJoinOnlyActiveGeneration, joinableParts: joinableParts, canJoinAllParts: canJoinAllParts, status: status, imageUrl: imageUrl)
    }
}
