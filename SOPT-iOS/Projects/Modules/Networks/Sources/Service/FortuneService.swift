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

public typealias DefaultFortuneService = BaseService<FortuneAPI>

public protocol FortuneService {
    func getTodaysFortuneCard() -> AnyPublisher<FortuneCardEntity, Error>
}

extension DefaultFortuneService: FortuneService {
    public func getTodaysFortuneCard() -> AnyPublisher<FortuneCardEntity, any Error> {
        requestObjectInCombine(.getTodaysFortuneCard)
    }
}
