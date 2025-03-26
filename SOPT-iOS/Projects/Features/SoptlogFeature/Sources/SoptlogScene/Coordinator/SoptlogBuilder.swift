//
//  SoptlogBuilder.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import SoptlogFeatureInterface

public final class SoptlogBuilder {
    @Injected public var soptlogReposiotry: SoptlogRepositoryInterface
    
    public init() {}
}

extension SoptlogBuilder: SoptlogFeatureBuildable {
    public func makeSoptlog() -> SoptlogPresentable {
        let useCase = DefaultSoptlogUseCase(repository: soptlogReposiotry)
        let viewModel = SoptlogViewModel(useCase: useCase)
        let soptlogVC = SoptlogVC(viewModel: viewModel)
        return (soptlogVC, viewModel)
    }
    
    public func makeSoptlogToolTip() -> SoptlogTooltipPresentable {
        let viewModel = SoptlogToolTipViewModel()
        let soptlogToolTipVC = SoptlogToolTipVC(viewModel: viewModel)
        return (soptlogToolTipVC, viewModel)
    }
}
