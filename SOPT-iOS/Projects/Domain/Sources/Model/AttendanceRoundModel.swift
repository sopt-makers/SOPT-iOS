//
//  AttendanceRoundModel.swift
//  Domain
//
//  Created by 김영인 on 2023/04/22.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AttendanceRoundModel {
    public let subLectureId: Int
    public let round: Int
    
    public init(subLectureId: Int, round: Int) {
        self.subLectureId = subLectureId
        self.round = round
    }
    
    public static let EMPTY: Self = .init(subLectureId: 0, round: 0)
}
