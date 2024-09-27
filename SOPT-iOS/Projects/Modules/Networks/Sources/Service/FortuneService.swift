//
//  FortuneService.swift
//  Networks
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Moya
import Network

public typealias DefaultFortuneService = BaseService<FortuneAPI>

public protocol FortuneService {
    func getDailySoptuneResult(date: String) -> AnyPublisher<DailyFortuneResultEntity, Error>
    func getTodaysFortuneCard() -> AnyPublisher<FortuneCardEntity, any Error>
}

extension DefaultFortuneService: FortuneService {
    public func getDailySoptuneResult(date: String) -> AnyPublisher<DailyFortuneResultEntity, Error> {
        requestObjectInCombine(.getDailySoptuneResult(date: date))
    }
        
    public func getTodaysFortuneCard() -> AnyPublisher<FortuneCardEntity, any Error> {
        requestObjectInCombine(.getTodaysFortuneCard)
    }
}
