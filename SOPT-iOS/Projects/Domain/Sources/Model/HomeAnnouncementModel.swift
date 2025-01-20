//
//  HomeAnnouncementModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeAnnouncementModel {
    public let id: Int
    public let categoryName, title, profileImage, name: String
    public let content: String
    public let images: [String]
    
    public init(id: Int, categoryName: String, title: String, profileImage: String, name: String, content: String, images: [String]) {
        self.id = id
        self.categoryName = categoryName
        self.title = title
        self.profileImage = profileImage
        self.name = name
        self.content = content
        self.images = images
    }
}
