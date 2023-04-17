//
//  ConfigService.swift
//  Network
//
//  Created by sejin on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Alamofire
import Moya

public typealias DefaultConfigService = BaseService<ConfigAPI>

public protocol ConfigService {
    func getServiceAvailability() -> AnyPublisher<ServiceStateEntity, Error>
}

extension DefaultConfigService: ConfigService {
    public func getServiceAvailability() -> AnyPublisher<ServiceStateEntity, Error> {
        requestObjectInCombine(.getServiceAvailability)
    }
}
