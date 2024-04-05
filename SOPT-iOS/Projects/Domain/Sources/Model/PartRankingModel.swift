//
//  PartRankingModel.swift
//  Domain
//
//  Created by Aiden.lee on 2024/04/05.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PartRankingModel {
  public let part: String
  public let rank: Int
  public let points: Int

  init(part: String, rank: Int, points: Int) {
    self.part = part
    self.rank = rank
    self.points = points
  }
}
