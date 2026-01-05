//
//  AppjamRankingRepository.swift
//  Data
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public class AppjamRankingRepository {

    private let appJamRankingService: AppJamRankingService

    public init(service: AppJamRankingService) {
        self.appJamRankingService = service
    }
}

extension AppjamRankingRepository: AppjamRankingRepositoryInterface {
    public func fetchTodayRanking(size: Int) async throws -> [AppjamRankTodayModel] {
        let entity = try await appJamRankingService.fetchTodayRanking(size: size)
        return entity.ranks.map { $0.toDomain() }
    }

    public func fetchRecentRanking(size: Int) async throws -> [AppjamRankRecentModel] {
        let entity = try await appJamRankingService.fetchRecentRanking(size: size)
        return entity.ranks.map { $0.toDomain() }
    }
}
