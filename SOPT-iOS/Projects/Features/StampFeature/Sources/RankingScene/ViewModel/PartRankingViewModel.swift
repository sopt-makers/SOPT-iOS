//
//  PartRankingViewModel.swift
//  StampFeature
//
//  Created by Aiden.lee on 2024/03/31.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import StampFeatureInterface

public class PartRankingViewModel: ViewModelType {
  private var cancelBag = CancelBag()

  private let rankingViewType: RankingViewType

  // MARK: - Inputs

  public struct Input {
    let viewDidLoad: Driver<Void>
    let refreshStarted: Driver<Void>
  }

  // MARK: - Outputs

  public class Output {
  }

  // MARK: - init

  public init(
    rankingViewType: RankingViewType
  ) {
    self.rankingViewType = rankingViewType
  }
}

extension PartRankingViewModel {
  public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
    Output()
  }
}
