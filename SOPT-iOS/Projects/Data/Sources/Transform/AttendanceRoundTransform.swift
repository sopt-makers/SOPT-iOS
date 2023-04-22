//
//  AttendanceLectureRoundTransform.swift
//  Data
//
//  Created by 김영인 on 2023/04/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Network

extension AttendanceRoundEntity {
    public func toDomain() -> AttendanceRoundModel {
        return AttendanceRoundModel.init(
            subLectureId: self.id,
            round: self.round
        )
    }
}
