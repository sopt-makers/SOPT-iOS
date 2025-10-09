//
//  LegacySoptlogBuilder.swift
//  SoptlogFeature
//
//  Created by 강윤서 on 11/25/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain
import BaseFeatureDependency
@_exported import SoptlogFeatureInterface

public final class LegacySoptlogBuilder {
    @Injected public var soptlogReposiotry: SoptlogRepositoryInterface
    
    public init() {}
}

extension LegacySoptlogBuilder: LegacySoptlogFeatureBuildable {
    public func makeSoptlog(coordinator: Coordinator) -> LegacySoptlogPresentable {
        let useCase = DefaultSoptlogUseCase(repository: soptlogReposiotry)
        let viewModel = SoptlogViewModel(useCase: useCase, coordinator: coordinator)
        let soptlogVC = SoptlogVC(viewModel: viewModel)
        return (soptlogVC, viewModel)
    }
    
    public func makeSoptlogToolTip(_ toolTipFrame: CGRect) -> LegacySoptlogTooltipPresentable {
        let viewModel = SoptlogToolTipViewModel()
        let soptlogToolTipVC = SoptlogToolTipVC(viewModel: viewModel, toolTipFrame: toolTipFrame)
        return (soptlogToolTipVC, viewModel)
    }
}
