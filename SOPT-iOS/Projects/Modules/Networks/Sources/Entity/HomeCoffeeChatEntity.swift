//
//  HomeCoffeeChatEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - HomeCoffeeChatEntity

public struct HomeCoffeeChatEntity: Codable {
    public let memberId: Int
    public let bio: String
    public let topicTypeList: [String]
    public let profileImage: String
    public let name: String
    public let career: String?
    public let organization: String
    public let companyJob: String?
    public let soptActivities: [String]
    public let currentSoptActivity: String?
}
