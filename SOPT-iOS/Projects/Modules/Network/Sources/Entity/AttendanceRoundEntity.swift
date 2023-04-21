//
//  AttendanceRoundEntity.swift
//  Network
//
//  Created by 김영인 on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AttendanceRoundEntity: Decodable {
    public let id: Int
    public let round: Int
}
