//
//  PartRankingTransform.swift
//  Data
//
//  Created by Aiden.lee on 2024/04/05.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

extension PartRankingEntity {
  public func toDomain() -> PartRankingModel {
    return .init(part: part, rank: rank, points: points)
  }
}

