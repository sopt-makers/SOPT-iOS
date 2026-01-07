//
//  AppjamRankTodayResponseEntity.swift
//  Networks
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AppjamRankTodayResponseEntity: Decodable {
    public let ranks: [AppjamRankToday]
}

public struct AppjamRankToday: Decodable {
    public let rank: Int
    public let teamName: String
    public let todayPoints: Int
    public let totalPoints: Int
}
