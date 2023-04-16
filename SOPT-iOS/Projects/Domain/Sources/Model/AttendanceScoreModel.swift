//
//  AttendanceScoreModel.swift
//  Domain
//
//  Created by devxsby on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AttendanceScoreModel: Codable, Hashable {
    public let part: String
    public let generation: Int
    public let name: String
    public let score: Double
    public let total: TotalScoreModel
    public let attendances: [AttendanceModel]
    
    public init(part: String, generation: Int, name: String, score: Double, total: TotalScoreModel, attendances: [AttendanceModel]) {
        self.part = part
        self.generation = generation
        self.name = name
        self.score = score
        self.total = total
        self.attendances = attendances
    }
    
}

public struct TotalScoreModel: Codable, Hashable {
    public let attendance, absent, tardy, participate: Int
    
    public init(attendance: Int, absent: Int, tardy: Int, participate: Int) {
        self.attendance = attendance
        self.absent = absent
        self.tardy = tardy
        self.participate = participate
    }
}

public struct AttendanceModel: Codable, Hashable {
    public let attribute, name, status, date: String
    
    public init(attribute: String, name: String, status: String, date: String) {
        self.attribute = attribute
        self.name = name
        self.status = status
        self.date = date
    }
}
