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

public class PartRankingViewModel: PartRankingViewModelType {
    
    // MARK: - Trigger
    public var onCellTap: ((StampFeatureInterface.Part) -> Void)?
    public var onNaviBackTap: (() -> Void)?
    public var onRightButtonTap: (() -> Void)?
    
    private let useCase: RankingUseCase
    private let rankingViewType: RankingViewType
    private var cancelBag = CancelBag()
    
    // MARK: - Inputs
    
    public struct Input {
        let viewDidLoad: Driver<Void>
        let refreshStarted: Driver<Void>
        let cellTapped: CurrentValueSubject<StampFeatureInterface.Part, Never>
        let naviBackButtonTapped: Driver<Void>
        let rightButtonTapped: Driver<Void>
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
            .withUnretained(self)
            .sink { owner, _ in
                AmplitudeInstance.shared.trackWithUserType(event: .viewPartRanking)
            }.store(in: cancelBag)
        
        input.viewDidLoad
            .merge(with: input.refreshStarted)
            .sink { [weak self] _ in
                self?.useCase.fetchPartRanking()
            }.store(in: cancelBag)
        
        input.cellTapped
            .dropFirst()
            .withUnretained(self)
            .sink { owner, part in
                owner.onCellTap?(part)
            }.store(in: cancelBag)
        
        input.naviBackButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onNaviBackTap?()
            }.store(in: cancelBag)
        
        input.rightButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                owner.onRightButtonTap?()
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
