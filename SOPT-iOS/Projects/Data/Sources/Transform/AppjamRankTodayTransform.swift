//
//  AppjamRankTodayTransform.swift
//  Data
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension AppjamRankToday {
    public func toDomain() -> AppjamRankTodayModel {
        return AppjamRankTodayModel(
            rank: self.rank,
            teamName: self.teamName,
            todayPoints: self.todayPoints,
            totalPoints: self.totalPoints
        )
    }
}
