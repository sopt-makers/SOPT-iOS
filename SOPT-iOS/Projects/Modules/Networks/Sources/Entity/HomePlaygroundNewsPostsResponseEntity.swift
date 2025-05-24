//
//  HomePlaygroundNewsPostsResponseEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - Entity

public struct HomePlaygroundNewsPostsResponseEntity: Codable {
    public let id: Int
    public let title, category: String
    public let profileImage: String?
    public let name: String?
    public let content: String
    public let isHotPost: Bool
}
