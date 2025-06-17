//
//  DailySoptuneBuilder.swift
//  DailySoptuneFeature
//
//  Created by 강윤서 on 6/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import DailySoptuneFeatureInterface

public final class DailySoptuneBuilder {
    @Injected public var dailySoptuneRepository: DailySoptuneRepositoryInterface
    @Injected public var pokeOnboardingRepository: PokeOnboardingRepositoryInterface
    
    public init() {}
}

extension DailySoptuneBuilder: DailySoptuneBuildable {
    public func makeDailySoptuneResultVC(resultModel: DailySoptuneResultModel) -> DailySoptuneResultPresentable {
        let useCase = DefaultDailySoptuneUseCase(repository: dailySoptuneRepository)
        let viewModel = DailySoptuneResultViewModel(useCase: useCase)
        let dailySoptuneResultVC = DailySoptuneResultVC(
            viewModel: viewModel,
            resultModel: resultModel)
        return (dailySoptuneResultVC, viewModel)
    }
    
    public func makeDailySoptuneMainVC() -> DailySoptuneMainPresentable {
        let useCase = DefaultDailySoptuneUseCase(repository: dailySoptuneRepository)
        let viewModel = DailySoptuneMainViewModel(useCase: useCase)
        let dailySoptuneMainVC = DailySoptuneMainVC(viewModel: viewModel)
        return (dailySoptuneMainVC, viewModel)
    }
    
    public func makeDailySoptuneCardVC(cardModel: DailySoptuneCardModel) -> DailySoptuneCardPresentable {
        let useCase = DefaultDailySoptuneUseCase(repository: dailySoptuneRepository)
        let viewModel = DailySoptuneCardViewModel(useCase: useCase)
        let dailySoptuneCardVC = DailySoptuneCardVC(cardModel: cardModel, viewModel: viewModel)
        return (dailySoptuneCardVC, viewModel)
    }
}
