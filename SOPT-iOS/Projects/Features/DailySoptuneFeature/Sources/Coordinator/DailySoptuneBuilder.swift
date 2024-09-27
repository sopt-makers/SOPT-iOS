//
//  DailySoptuneBuilder.swift
//  DailySoptuneFeatureInterface
//
//  Created by Jae Hyun Lee on 9/21/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import DailySoptuneFeatureInterface
import PokeFeature
import PokeFeatureInterface

public final class DailySoptuneBuilder {
    @Injected public var dailySoptuneRepository: DailySoptuneRepositoryInterface
    @Injected public var pokeOnboardingRepository: PokeOnboardingRepositoryInterface
    
    public init() {}
}

extension DailySoptuneBuilder: DailySoptuneFeatureBuildable {
    
    public func makeDailySoptuneResultVC() -> DailySoptuneFeatureInterface.DailySoptuneResultPresentable {
        let useCase = DefaultDailySoptuneUseCase(repository: dailySoptuneRepository)
        let viewModel = DailySoptuneResultViewModel(useCase: useCase)
        let dailySoptuneResultVC = DailySoptuneResultVC(viewModel: viewModel)
        return (dailySoptuneResultVC, viewModel)
    }
    
    public func makePokeMessageTemplateBottomSheet(messageType: Domain.PokeMessageType) -> PokeFeatureInterface.PokeMessageTemplatesPresentable {
        let useCase = DefaultPokeMessageTemplateUsecase(repository: self.pokeOnboardingRepository)
        let viewModel = PokeMessageTemplateViewModel(messageType: messageType, usecase: useCase)
        let viewController = PokeMessageTemplateBottomSheet(viewModel: viewModel)
        return (viewController, viewModel)
    }
	
	public func makeDailySoptuneMainVC() -> DailySoptuneMainPresentable {
        let useCase = DefaultDailySoptuneUseCase(repository: dailySoptuneRepository)
        let viewModel = DailySoptuneMainViewModel(useCase: useCase)
		let dailySoptuneMainVC = DailySoptuneMainVC(viewModel: viewModel)
		return (dailySoptuneMainVC, viewModel)
	}
}
