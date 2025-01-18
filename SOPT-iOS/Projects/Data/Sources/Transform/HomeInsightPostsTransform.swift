//
//  HomeInsightPostsTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomeInsightPostsEntity {
    public func toDomain() -> [HomeInsightPostsModel] {
        return [HomeInsightPostsModel(id: id, title: title, category: category, content: content, isHotPost: isHotPost)]
    }
}
