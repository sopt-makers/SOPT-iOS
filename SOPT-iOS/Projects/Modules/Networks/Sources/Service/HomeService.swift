//
//  HomeService.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Moya

public typealias DefaultHomeService = BaseService<HomeAPI>

public protocol HomeService {
    func getDescription() -> AnyPublisher<HomeDescriptionEntity, Error>
}

extension DefaultHomeService: HomeService {
    public func getDescription() -> AnyPublisher<HomeDescriptionEntity, any Error> {
        requestObjectInCombine(.getDescription)
    }
}
