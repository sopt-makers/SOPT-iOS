//
//  PartRankingEntity.swift
//  Networks
//
//  Created by Aiden.lee on 2024/04/05.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PartRankingEntity: Decodable {
    public let part: String
    public let rank: Int
    public let points: Int
    public let pointsDecimal: Double
}
