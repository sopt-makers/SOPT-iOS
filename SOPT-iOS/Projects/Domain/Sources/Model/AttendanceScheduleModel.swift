//
//  AttendanceScheduleModel.swift
//  Domain
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AttendanceScheduleModel {
    public let type: String
    public let location, name, startDate, endDate: String
    public let message: String
    public let attendances: [TodayAttendanceModel]
    
    public init(type: String, location: String, name: String, startDate: String, endDate: String, message: String, attendances: [TodayAttendanceModel]) {
        self.type = type
        self.location = location
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.message = message
        self.attendances = attendances
    }
}

public struct TodayAttendanceModel {
    public let status, attendedAt: String
    
    public init(status: String, attendedAt: String) {
        self.status = status
        self.attendedAt = attendedAt
    }
}
