//
//  AppjamRankRecentResponseEntity.swift
//  Networks
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AppjamRankRecentResponseEntity: Decodable {
    public let ranks: [AppjamRankRecent]
}

public struct AppjamRankRecent: Decodable {
    public let stampId: Int
    public let missionId: Int
    public let userId: Int
    public let imageUrl: String
    public let createdAt: String
    public let userName: String
    public let userProfileImage: String
    public let teamName: String
    public let teamNumber: String
}
