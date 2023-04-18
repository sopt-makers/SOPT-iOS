//
//  AttendanceStateType.swift
//  Core
//
//  Created by devxsby on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum AttendanceStateType: String {
    case attendance
    case tardy
    case absent
    case participate
    
    public var korean: String {
        switch self {
        case .attendance: return "출석"
        case .tardy: return "지각"
        case .absent: return "결석"
        case .participate: return "참여"
        }
    }
}
