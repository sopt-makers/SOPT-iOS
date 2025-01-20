//
//  HomeInsightPostsModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

public struct HomeInsightPostsModel {
    public var id: Int
    public var title, category: String
    public var profileImage: String?
    public var name: String?
    public var content: String
    public var isHotPost: Bool
    
    public init(id: Int, title: String, category: String, profileImage: String? = nil, name: String? = nil, content: String, isHotPost: Bool) {
        self.id = id
        self.title = title
        self.category = category
        self.profileImage = profileImage
        self.name = name
        self.content = content
        self.isHotPost = isHotPost
    }
}
