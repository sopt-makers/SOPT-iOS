//
//  FortuneService.swift
//  Networks
//
//  Created by 강윤서 on 9/27/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Moya

public typealias DefaultFortuneService = BaseService<FortuneAPI>

public protocol FortuneService {
    func getTodayFortune(date: String) -> AnyPublisher<DailyFortuneEntity, Error>
}

extension DefaultFortuneService: FortuneService {
    public func getTodayFortune(date: String) -> AnyPublisher<DailyFortuneEntity, Error> {
        requestObjectInCombine(.getTodayFortune(date: date))
    }
}
