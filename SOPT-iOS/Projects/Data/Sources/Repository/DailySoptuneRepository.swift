//
//  DailySoptuneRepository.swift
//  Data
//
//  Created by 강윤서 on 9/27/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Networks

public class DailySoptuneRepository {
    
    private let fortuneService: FortuneService
    private let cancelBag = CancelBag()
    
    public init(fortuneService: FortuneService) {
        self.fortuneService = fortuneService
    }
}

extension DailySoptuneRepository: DailySoptuneRepositoryInterface {
    public func getDailySoptuneResult(date: String) -> AnyPublisher<DailySoptuneResultModel, Error> {
        self.fortuneService
            .getDailySoptuneResult(date: date)
            .map{ $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
