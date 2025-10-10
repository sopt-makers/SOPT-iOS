//
//  AttendanceResponseEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 10/10/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AttendanceResponseEntity: Codable {
    public let subLectureId: Int
    
    public init(subLectureId: Int) {
        self.subLectureId = subLectureId
    }
}
