//
//  HomeEmploymentEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/20/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - HomeEmploymentEntity

public struct HomeEmploymentEntity: Codable {
    public let id: Int
    public let profileImage, name: String?
    public let categoryName, title: String
    public let content: String
    public let images: [String]
}
