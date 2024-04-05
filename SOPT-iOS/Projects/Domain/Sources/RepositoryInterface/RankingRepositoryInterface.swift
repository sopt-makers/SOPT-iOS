//
//  RankingRepositoryInterface.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol RankingRepositoryInterface {
  func fetchRankingListModel(isCurrentGeneration: Bool) -> AnyPublisher<[RankingModel], Error>
  func fetchPartRanking() -> AnyPublisher<[Domain.PartRankingModel], Error>
  func fetchRankingListInPart(part: String) -> AnyPublisher<[RankingModel], Error>
}
