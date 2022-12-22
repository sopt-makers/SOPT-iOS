//
//  RankingModel.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct RankingModel: Hashable {
    public let username: String
    public let usreId: Int
    public let score: Int
    public let sentence: String
    
    public init(username: String, usreId: Int, score: Int, sentence: String) {
        self.username = username
        self.usreId = usreId
        self.score = score
        self.sentence = sentence
    }
}

public struct RankingChartModel: Hashable {
    public let ranking: [RankingModel]
    
    public init(ranking: [RankingModel]) {
        self.ranking = ranking
    }
}
