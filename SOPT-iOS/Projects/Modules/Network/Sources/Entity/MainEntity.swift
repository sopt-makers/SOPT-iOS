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
    public let operation: Operation?
    public let statusCode, responseMessage: String?
}

// MARK: - User

public struct UserInfo: Codable {
    public let status, name, profileImage: String
    public let generationList: [Int]
}

// MARK: - Operation

public struct Operation: Codable {
    public let attendanceScore: Int
    public let announcement: String
}


