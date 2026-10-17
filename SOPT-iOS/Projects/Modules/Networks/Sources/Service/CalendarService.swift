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
    func getRecentScheduleAsync() async throws -> CalendarRecentEntity
    func getCalendarDetailAsync() async throws -> [HomeCalendarDetailResponseEntity]
}

extension DefaultCalendarService: CalendarService {
    public func getRecentScheduleAsync() async throws -> CalendarRecentEntity {
        try await requestObjectAsync(.getRecentSchedule)
    }
    
    public func getCalendarDetailAsync() async throws -> [HomeCalendarDetailResponseEntity] {
        try await requestObjectAsync(.getCalendarDetail)
    }
}
