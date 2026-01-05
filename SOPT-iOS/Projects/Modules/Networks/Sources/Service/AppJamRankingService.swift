//
//  AppJamRankingService.swift
//  Networks
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Moya

public typealias DefaultAppJamRankingService = BaseService<AppjamRankAPI>

public protocol AppJamRankingService {
    func fetchTodayRanking(size: Int) async throws -> AppjamRankTodayResponseEntity
    func fetchRecentRanking(size: Int) async throws -> AppjamRankRecentResponseEntity
}

extension DefaultAppJamRankingService: AppJamRankingService {
    public func fetchTodayRanking(size: Int) async throws -> AppjamRankTodayResponseEntity {
        try await requestObjectAsync(.today(size: size))
    }

    public func fetchRecentRanking(size: Int) async throws -> AppjamRankRecentResponseEntity {
        try await requestObjectAsync(.recent(size: size))
    }
}
