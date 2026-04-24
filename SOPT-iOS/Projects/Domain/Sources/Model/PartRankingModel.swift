//
//  PartRankingModel.swift
//  Domain
//
//  Created by Aiden.lee on 2024/04/05.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PartRankingModel: Hashable {
    public let part: String
    public let rank: Int
    public let points: Int
    public let pointsDecimal: Double
    
    public init(part: String, rank: Int, points: Int, pointsDecimal: Double) {
        self.part = part
        self.rank = rank
        self.points = points
        self.pointsDecimal = pointsDecimal
    }
}

public struct PartRankingChartModel: Hashable {
    public let ranking: [PartRankingModel]
    
    public init(ranking: [PartRankingModel]) {
        self.ranking = ranking
    }
}
