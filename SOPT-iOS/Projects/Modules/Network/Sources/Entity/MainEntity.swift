//
//  MainEntity.swift
//  MainFeature
//
//  Created by sejin on 2023/04/01.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct MainEntity: Codable {
    public let user: UserInfo?
    public let operation: OperationInfo?
    public let statusCode, responseMessage: String?
}

// MARK: - UserInfo

public struct UserInfo: Codable {
    public let status, name, profileImage: String
    public let historyList: [Int]
    
    enum CodingKeys: String, CodingKey {
        case historyList = "generationList"
        case status, name, profileImage
    }
}

// MARK: - OperationInfo

public struct OperationInfo: Codable {
    public let attendanceScore: Float
    public let announcement: String
}


