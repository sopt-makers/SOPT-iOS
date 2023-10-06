//
//  AttendanceScheduleEntity.swift
//  Network
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AttendanceScheduleEntity: Codable {
    public let type: String
    public let id: Int
    public let location, name, startDate, endDate: String
    public let message: String
    public let attendances: [TodayAttendance]
}

public struct TodayAttendance: Codable {
    public let status, attendedAt: String
}
