//
//  AttendanceScoreEntity.swift
//  Network
//
//  Created by devxsby on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AttendanceScoreEntity: Codable {
    public let part: String
    public let generation: Int
    public let name: String
    public let score: Double
    public let total: TotalScore
    public let attendances: [Attendance]
}

public struct Attendance: Codable {
    public let attribute, name, status, date: String
}

public struct TotalScore: Codable {
    public let attendance, absent, tardy, participate: Int
}
