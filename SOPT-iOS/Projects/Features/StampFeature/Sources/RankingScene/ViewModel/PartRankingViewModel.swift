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

  private let useCase: RankingUseCase
  private let rankingViewType: RankingViewType
  private var cancelBag = CancelBag()

  // MARK: - Inputs

  public struct Input {
    let viewDidLoad: Driver<Void>
    let refreshStarted: Driver<Void>
  }

  // MARK: - Outputs

  public class Output {
    let partRanking = PassthroughSubject<[PartRankingModel], Never>()
  }

  // MARK: - init

  public init(
    rankingViewType: RankingViewType,
    useCase: RankingUseCase
  ) {
    self.rankingViewType = rankingViewType
    self.useCase = useCase
  }
}

extension PartRankingViewModel {
  public func transform(from input: Input, cancelBag: Core.CancelBag) -> Output {
    let output = Output()
    self.bindOutput(output: output, cancelBag: cancelBag)
    
    input.viewDidLoad
      .merge(with: input.refreshStarted)
      .sink { [weak self] _ in
        self?.useCase.fetchPartRanking()
      }.store(in: cancelBag)

    return output
  }

  private func bindOutput(output: Output, cancelBag: CancelBag) {
    useCase.partRanking
      .asDriver()
      .sink { rankingModels in
        output.partRanking.send(rankingModels)
      }.store(in: cancelBag)
  }
}
