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

  public init(part: String, rank: Int, points: Int) {
    self.part = part
    self.rank = rank
    self.points = points
  }
}

public struct PartRankingChartModel: Hashable {
  public let ranking: [PartRankingModel]
  
  public init(ranking: [PartRankingModel]) {
    self.ranking = ranking
  }
}
