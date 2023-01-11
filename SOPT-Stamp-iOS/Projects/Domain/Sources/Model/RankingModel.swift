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
    public let userId: Int
    public let score: Int
    public let sentence: String
    
    public var isMyRanking: Bool = false
    
    public init(username: String, usreId: Int, score: Int, sentence: String) {
        self.username = username
        self.userId = usreId
        self.score = score
        self.sentence = sentence
    }
    
    public
    mutating func setMyRanking(_ isMyRanking: Bool) {
        self.isMyRanking = isMyRanking
    }
}

public struct RankingChartModel: Hashable {
    public let ranking: [RankingModel]
    
    public init(ranking: [RankingModel]) {
        self.ranking = ranking
    }
}
