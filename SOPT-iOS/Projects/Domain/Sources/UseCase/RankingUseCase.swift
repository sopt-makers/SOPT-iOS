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
    func fetchRankingList(isCurrentGeneration: Bool)
    func findMyRanking()
    var rankingListModelFetched: CurrentValueSubject<[RankingModel], Error> { get }
    var myRanking: PassthroughSubject<(section: Int, item: Int), Error> { get set }
}

public class DefaultRankingUseCase {
    
    private let repository: RankingRepositoryInterface
    private var cancelBag = CancelBag()
    public var rankingListModelFetched = CurrentValueSubject<[RankingModel], Error>([])
    public var myRanking = PassthroughSubject<(section: Int, item: Int), Error>()
    
    public init(repository: RankingRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultRankingUseCase: RankingUseCase {
    public func fetchRankingList(isCurrentGeneration: Bool) {
        self.repository
            .fetchRankingListModel(isCurrentGeneration: isCurrentGeneration)
            .map { model in
                var newModel = model
                let myRankingIndex = self.findMyRankingIndex(model: model)
                newModel[myRankingIndex].setMyRanking(true)
                return newModel
            }
            .withUnretained(self)
            .sink { completion in
                print(completion)
            } receiveValue: { owner, model in
                owner.rankingListModelFetched.send(model)
            }.store(in: self.cancelBag)
    }
    
    public func findMyRanking() {
        let myRankingIndex = self.findMyRankingIndex(model: rankingListModelFetched.value)
        
        if myRankingIndex > 2 {
            myRanking.send((1, myRankingIndex - 3))
        } else {
            myRanking.send((0, 0))
        }
    }
    
    private func findMyRankingIndex(model: [RankingModel]) -> Int {
        let myUserName = UserDefaultKeyList.User.soptampName
        let index = model.firstIndex { model in
            model.username == myUserName
        } ?? 0
        return index
    }
}
