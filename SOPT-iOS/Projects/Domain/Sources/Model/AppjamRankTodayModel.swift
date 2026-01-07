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
    public let todayPoints: Int
    public let totalPoints: Int

    public init(rank: Int, teamName: String, todayPoints: Int, totalPoints: Int) {
        self.rank = rank
        self.teamName = teamName
        self.todayPoints = todayPoints
        self.totalPoints = totalPoints
    }
}
