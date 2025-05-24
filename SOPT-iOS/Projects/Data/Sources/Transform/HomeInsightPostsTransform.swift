//
//  HomePlaygroundNewsPostsTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomePlaygroundNewsPostsResponseEntity {
    public func toDomain() -> HomePlaygroundNewsPostsModel {
        return HomePlaygroundNewsPostsModel(id: id, title: title, category: category, content: content, isHotPost: isHotPost)
    }
}
