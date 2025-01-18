//
//  CalendarService.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Combine

import Moya

public typealias DefaultCalendarService = BaseService<CalendarAPI>

public protocol CalendarService {
    func getRecentSchedule() -> AnyPublisher<CalendarRecentEntity, Error>
}

extension DefaultCalendarService: CalendarService {
    public func getRecentSchedule() -> AnyPublisher<CalendarRecentEntity, any Error> {
        requestObjectInCombine(.getRecentSchedule)
    }
}
