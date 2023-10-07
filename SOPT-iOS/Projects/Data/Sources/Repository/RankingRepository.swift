//
//  RankingRepository.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class RankingRepository {
    
    private let rankService: RankService
    private let cancelBag = CancelBag()
    
    public init(service: RankService) {
        self.rankService = service
    }
}

extension RankingRepository: RankingRepositoryInterface {
    public func fetchRankingListModel(isCurrentGeneration: Bool) -> AnyPublisher<[Domain.RankingModel], Error> {
        return self.rankService
            .fetchRankingList(isCurrentGeneration: isCurrentGeneration)
            .map({ entity in
                entity.map { $0.toDomain() }
            })
            .eraseToAnyPublisher()
    }
}
