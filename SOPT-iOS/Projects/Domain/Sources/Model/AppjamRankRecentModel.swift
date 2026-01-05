//
//  AppjamRankRecentModel.swift
//  Domain
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AppjamRankRecentModel {
    public let stampId: Int
    public let missionId: Int
    public let userId: Int
    public let imageUrl: String
    public let createdAt: String
    public let userName: String
    public let userProfileImage: String
    public let teamName: String
    public let teamNumber: String

    public init(
        stampId: Int,
        missionId: Int,
        userId: Int,
        imageUrl: String,
        createdAt: String,
        userName: String,
        userProfileImage: String,
        teamName: String,
        teamNumber: String
    ) {
        self.stampId = stampId
        self.missionId = missionId
        self.userId = userId
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        self.userName = userName
        self.userProfileImage = userProfileImage
        self.teamName = teamName
        self.teamNumber = teamNumber
    }
}
