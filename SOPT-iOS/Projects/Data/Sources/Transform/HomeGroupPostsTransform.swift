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
        return HomeGroupPostModel(id: id,
                                  title: title,
                                  category: HomeGroupPostModel.Category(rawValue: category) ?? .event,
                                  canJoinOnlyActiveGeneration: canJoinOnlyActiveGeneration,
                                  joinableParts: joinableParts,
                                  canJoinAllParts: canJoinAllParts,
                                  status: HomeGroupPostModel.Status(rawValue: status) ?? .applyAble, imageUrl: imageUrl)
    }
}
