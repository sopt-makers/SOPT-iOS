//
//  AppjamRankingUseCase.swift
//  Domain
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol AppjamRankingUseCase {
    func fetchTodayRanking(size: Int) async throws -> [AppjamRankTodayModel]
    func fetchRecentRanking(size: Int) async throws -> [AppjamRankRecentModel]
    func fetchAppjamInfo() async throws -> AppjamInfoModel
}

public class DefaultAppjamRankingUseCase {

    private let repository: AppjamRankingRepositoryInterface

    public init(repository: AppjamRankingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultAppjamRankingUseCase: AppjamRankingUseCase {
    public func fetchTodayRanking(size: Int) async throws -> [AppjamRankTodayModel] {
        try await repository.fetchTodayRanking(size: size)
    }

    public func fetchRecentRanking(size: Int) async throws -> [AppjamRankRecentModel] {
        try await repository.fetchRecentRanking(size: size)
    }
    
    public func fetchAppjamInfo() async throws -> AppjamInfoModel {
        try await repository.fetchAppjamInfo()
    }
}
