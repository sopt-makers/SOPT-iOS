//
//  SessionType.swift
//  Core
//
//  Created by 김영인 on 2023/04/21.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public enum SessionType: String, CaseIterable {
    case noSession = "NO_SESSION"
    case hasAttendance = "HAS_ATTENDANCE"
    case noAttendance = "NO_ATTENDANCE"
}
