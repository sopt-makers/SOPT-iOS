//
//  AttendanceScheduleTransform.swift
//  Data
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Network

extension AttendanceScheduleEntity {

    public func toDomain() -> AttendanceScheduleModel {
        return .init(type: self.type,
                     location: self.location,
                     name: self.name,
                     startDate: self.startDate,
                     endDate: self.endDate,
                     message: self.message,
                     attendances: self.attendances.map { $0.toDomain() })
    }
}

extension TodayAttendance {
    
    public func toDomain() -> TodayAttendanceModel {
        return .init(status: self.status,
                     attendedAt: self.attendedAt)
    }
}
