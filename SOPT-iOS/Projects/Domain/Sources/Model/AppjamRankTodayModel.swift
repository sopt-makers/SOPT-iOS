//
//  AppjamRankTodayModel.swift
//  Domain
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AppjamRankTodayModel {
    public let rank: Int
    public let teamName: String
    public let teamNumber: String
    public let todayPoints: Int
    public let totalPoints: Int

    public init(rank: Int, teamName: String, teamNumber: String, todayPoints: Int, totalPoints: Int) {
        self.rank = rank
        self.teamName = teamName
        self.teamNumber = teamNumber
        self.todayPoints = todayPoints
        self.totalPoints = totalPoints
    }
}
