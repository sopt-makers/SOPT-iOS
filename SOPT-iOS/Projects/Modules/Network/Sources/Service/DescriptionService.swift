//
//  DescriptionService.swift
//  Network
//
//  Created by sejin on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Moya
import Core

public typealias DefaultDescriptionService = BaseService<DescriptionAPI>

public protocol DescriptionService {
    func getMainViewDescription() -> AnyPublisher<MainDescriptionEntity, Error>
}

extension DefaultDescriptionService: DescriptionService {
    public func getMainViewDescription() -> AnyPublisher<MainDescriptionEntity, Error> {
        requestObjectInCombine(.getMainViewDescription)
    }
}
