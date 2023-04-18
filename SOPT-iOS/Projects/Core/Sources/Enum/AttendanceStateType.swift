//
//  AttendanceStateType.swift
//  Core
//
//  Created by devxsby on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum AttendanceStateType: String, CaseIterable {
    case attendance = "출석"
    case tardy = "지각"
    case absent = "결석"
    case participate = "참여"
}
