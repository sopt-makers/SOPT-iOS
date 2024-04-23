//
//  RankingModel.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

// MARK: - RankingModel
public struct RankingModel {
  public let username: String
  public let score: Int
  public let sentence: String
  
  public var isMyRanking: Bool = false
  
  public init(username: String, score: Int, sentence: String) {
    self.username = username
    self.score = score
    self.sentence = sentence
  }
  
  public
  mutating func setMyRanking(_ isMyRanking: Bool) {
    self.isMyRanking = isMyRanking
  }
}

extension RankingModel: Hashable, Identifiable {
  public var id: String { UUID().uuidString }
}

// MARK: - RankingChartModel
public struct RankingChartModel {
  public let ranking: [RankingModel]
  
  public init(ranking: [RankingModel]) {
    self.ranking = ranking
  }
}

extension RankingChartModel: Hashable, Identifiable {
  public var id: String { UUID().uuidString }
}
