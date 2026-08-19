//
//  AppJamRankingPresentationModel.swift
//  StampFeature
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Core

// MARK: - Today Ranking Presentation Model

struct AppJamRankTodayPresentationModel: Hashable {
    let rank: Int
    let teamName: String
    let teamNumber: String
    let todayPoints: Int
    let totalPoints: Int

    init(from domainModel: AppjamRankTodayModel) {
        self.rank = domainModel.rank
        self.teamName = domainModel.teamName
        self.teamNumber = domainModel.teamNumber
        self.todayPoints = domainModel.todayPoints
        self.totalPoints = domainModel.totalPoints
    }
}

// MARK: - Recent Mission Presentation Model

struct AppJamRankRecentPresentationModel: Hashable {
    let stampId: Int
    let missionId: Int
    let userId: Int
    let imageUrl: String
    let relativeTime: String
    let userName: String
    let userProfileImage: String
    let teamName: String
    let teamNumber: String
    let ownerNickname: String

    init(from domainModel: AppjamRankRecentModel) {
        self.stampId = domainModel.stampId
        self.missionId = domainModel.missionId
        self.userId = domainModel.userId
        self.imageUrl = domainModel.imageUrl
        self.relativeTime = calculatePastTime(date: domainModel.createdAt, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        self.userName = domainModel.userName
        self.userProfileImage = domainModel.userProfileImage
        self.teamName = domainModel.teamName
        self.teamNumber = domainModel.teamNumber
        self.ownerNickname = domainModel.ownerNickname
    }
}
