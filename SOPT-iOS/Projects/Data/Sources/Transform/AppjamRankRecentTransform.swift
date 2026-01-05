//
//  AppjamRankRecentTransform.swift
//  Data
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension AppjamRankRecent {
    public func toDomain() -> AppjamRankRecentModel {
        return AppjamRankRecentModel(
            stampId: self.stampId,
            missionId: self.missionId,
            userId: self.userId,
            imageUrl: self.imageUrl,
            createdAt: self.createdAt,
            userName: self.userName,
            userProfileImage: self.userProfileImage,
            teamName: self.teamName,
            teamNumber: self.teamNumber
        )
    }
}
