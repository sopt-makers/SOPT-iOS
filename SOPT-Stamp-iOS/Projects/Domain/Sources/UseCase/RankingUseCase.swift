//
//  RankingUseCase.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core

public protocol RankingUseCase {
    func fetchRankingList()
    var rankingListModelFetched: PassthroughSubject<[RankingModel], Error> { get }
}

public class DefaultRankingUseCase {
    
    private let repository: RankingRepositoryInterface
    private var cancelBag = CancelBag()
    public var rankingListModelFetched = PassthroughSubject<[RankingModel], Error>()
    
    public init(repository: RankingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultRankingUseCase: RankingUseCase {
    public func fetchRankingList() {
        self.repository.fetchRankingListModel()
            .withUnretained(self)
            .sink { completion in
                print(completion)
            } receiveValue: { owner, model in
                owner.rankingListModelFetched.send(model)
            }.store(in: self.cancelBag)
    }
}
