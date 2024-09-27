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

public final class DailySoptuneBuilder {
    @Injected public var dailySoptuneRepository: DailySoptuneRepositoryInterface
    
    public init() {}
}

extension DailySoptuneBuilder: DailySoptuneFeatureBuildable {
    public func makeDailySoptuneResultVC() -> any DailySoptuneFeatureInterface.DailySoptuneResultViewControllable {
        let viewModel = DailySoptuneResultViewModel()
        let dailySoptuneResultVC = DailySoptuneResultVC(viewModel: viewModel)
        return dailySoptuneResultVC
    }
	
	public func makeDailySoptuneMainVC() -> DailySoptuneMainPresentable {
        let useCase = DefaultDailySoptuneUseCase(repository: dailySoptuneRepository)
        let viewModel = DailySoptuneMainViewModel(useCase: useCase)
		let dailySoptuneMainVC = DailySoptuneMainVC(viewModel: viewModel)
		return (dailySoptuneMainVC, viewModel)
	}
}
