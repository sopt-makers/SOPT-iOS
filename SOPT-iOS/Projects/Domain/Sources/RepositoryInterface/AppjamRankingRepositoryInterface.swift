//
//  AppjamRankingRepositoryInterface.swift
//  Domain
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol AppjamRankingRepositoryInterface {
    func fetchTodayRanking(size: Int) async throws -> [AppjamRankTodayModel]
    func fetchRecentRanking(size: Int) async throws -> [AppjamRankRecentModel]
    func fetchAppjamInfo() async throws -> AppjamInfoModel
}
