//
//  RankingUseCase.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

public protocol RankingUseCase {

}

public class DefaultRankingUseCase {
  
    private let repository: RankingRepositoryInterface
    private var cancelBag = Set<AnyCancellable>()
  
    public init(repository: RankingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultRankingUseCase: RankingUseCase {
  
}
