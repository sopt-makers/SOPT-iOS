//
//  AttendanceScoreTransform.swift
//  Data
//
//  Created by devxsby on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Network

extension AttendanceScoreEntity {

    public func toDomain() -> AttendanceScoreModel {
        .init(part: self.part,
              generation: self.generation,
              name: self.name,
              score: self.score,
              total: self.total.toDomain(),
              attendances: self.attendances.map { $0.toDomain() } )
    }
}

extension TotalScore {
    public func toDomain() -> TotalScoreModel {
        .init(attendance: self.attendance,
              absent: self.absent,
              tardy: self.tardy,
              participate: self.participate)
    }
}

extension Attendance {
    public func toDomain() -> AttendanceModel {
        .init(attribute: self.attribute,
              name: self.name,
              status: self.status,
              date: self.date)
    }
}
