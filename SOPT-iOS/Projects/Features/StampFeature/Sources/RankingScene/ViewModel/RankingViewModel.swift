//
//  RankingViewModel.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain

public class RankingViewModel: ViewModelType {
    
    private let useCase: RankingUseCase
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let refreshStarted: Driver<Void>
        let showMyRankingButtonTapped: Driver<Void>
    }
    
    // MARK: - Outputs
    
    public class Output {
        @Published var rankingListModel = [RankingModel]()
        @Published var myRanking = (section: 0, item: 0)
    }
    
    // MARK: - init
    
    public init(useCase: RankingUseCase) {
        self.useCase = useCase
    }
}

extension RankingViewModel {
    public func transform(from input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        self.bindOutput(output: output, cancelBag: cancelBag)
        
        input.viewDidLoad.merge(with: input.refreshStarted)
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.fetchRankingList()
            }.store(in: self.cancelBag)
        
        input.showMyRankingButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.findMyRanking()
            }.store(in: self.cancelBag)
        
        return output
    }
    
    private func bindOutput(output: Output, cancelBag: CancelBag) {
        let fetchedRankingList = self.useCase.rankingListModelFetched
        
        fetchedRankingList.asDriver()
            .sink(receiveValue: { model in
                output.rankingListModel = model
            })
            .store(in: self.cancelBag)
        
        self.useCase.myRanking
            .asDriver()
            .sink(receiveValue: { indexPath in
                output.myRanking = indexPath
            })
            .store(in: self.cancelBag)
    }
}
