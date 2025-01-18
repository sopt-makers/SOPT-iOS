//
//  HomeGroupEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - HomeGroupEntity

public struct HomeGroupEntity: Codable {
    public let id: Int
    public let title: String
    public let category: String
    public let canJoinOnlyActiveGeneration: Bool
    public let joinableParts: [String]
    public let canJoinAllParts: Bool
    public let status: Status
    public let imageUrl: String
    
    // MARK: - Status Enum
    public enum Status: String, Codable {
        case beforeStart = "BEFORE_START"
        case applyAble = "APPLY_ABLE"
        case recruitmentComplete = "RECRUITMENT_COMPLETE"
    }
}
