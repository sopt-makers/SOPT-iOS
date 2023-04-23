//
//  AttendanceScoreTransform.swift
//  Data
//
//  Created by devxsby on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain
import Network

enum PartType: String, CaseIterable {
    case planPart = "PLAN"
    case designPart = "DESIGN"
    case webPart = "WEB"
    case iosPart = "IOS"
    case aosPart = "ANDRIOD"
    case serverPart = "SERVER"
    
    var partName: String {
        switch self {
        case .planPart:
            return I18N.Attendance.planPart
        case .designPart:
            return I18N.Attendance.designPart
        case .webPart:
            return I18N.Attendance.webPart
        case .iosPart:
            return I18N.Attendance.iosPart
        case .aosPart:
            return I18N.Attendance.aosPart
        case .serverPart:
            return I18N.Attendance.serverPart
        }
    }
}

extension AttendanceScoreEntity {
    
    private func changePartName(_ part: String) -> String {
        var partName: String = ""
        PartType.allCases.forEach {
            if $0.rawValue == part {
                partName = $0.partName
                return
            }
        }
        return partName
    }

    public func toDomain() -> AttendanceScoreModel {
        .init(part: changePartName(self.part),
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
