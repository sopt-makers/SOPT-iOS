//
//  LegacyDailySoptuneBuilder.swift
//  DailySoptuneFeatureInterface
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import DailySoptuneFeatureInterface

public final class LegacyDailySoptuneBuilder {
    @Injected public var dailySoptuneRepository: DailySoptuneRepositoryInterface
    @Injected public var pokeOnboardingRepository: PokeOnboardingRepositoryInterface
    
    public init() {}
}

extension LegacyDailySoptuneBuilder: LegacyDailySoptuneFeatureBuildable {
    
    public func makeDailySoptuneResultVC(resultModel: DailySoptuneResultModel) -> LegacyDailySoptuneResultPresentable {
        let useCase = DefaultDailySoptuneUseCase(repository: dailySoptuneRepository)
        let viewModel = DailySoptuneResultViewModel(useCase: useCase)
        let dailySoptuneResultVC = DailySoptuneResultVC(
            viewModel: viewModel,
            resultModel: resultModel)
        return (dailySoptuneResultVC, viewModel)
    }
	
	public func makeDailySoptuneMainVC() -> LegacyDailySoptuneMainPresentable {
        let useCase = DefaultDailySoptuneUseCase(repository: dailySoptuneRepository)
        let viewModel = DailySoptuneMainViewModel(useCase: useCase)
		let dailySoptuneMainVC = DailySoptuneMainVC(viewModel: viewModel)
		return (dailySoptuneMainVC, viewModel)
	}
    
    public func makeDailySoptuneCardVC(cardModel: DailySoptuneCardModel) -> LegacyDailySoptuneCardPresentable {
        let useCase = DefaultDailySoptuneUseCase(repository: dailySoptuneRepository)
        let viewModel = DailySoptuneCardViewModel(useCase: useCase)
        let dailySoptuneCardVC = DailySoptuneCardVC(cardModel: cardModel, viewModel: viewModel)
        return (dailySoptuneCardVC, viewModel)
    }
    
}
