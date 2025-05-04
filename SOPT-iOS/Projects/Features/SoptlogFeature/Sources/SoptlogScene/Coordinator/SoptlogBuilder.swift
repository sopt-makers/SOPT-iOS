//
//  SoptlogBuilder.swift
//  SoptlogFeatureInterface
//
//  Created by Jae Hyun Lee on 5/5/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

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
    
    public func makeSoptlogToolTip(_ toolTipFrame: CGRect) -> SoptlogTooltipPresentable {
        let viewModel = SoptlogToolTipViewModel()
        let soptlogToolTipVC = SoptlogToolTipVC(viewModel: viewModel, toolTipFrame: toolTipFrame)
        return (soptlogToolTipVC, viewModel)
    }
}
