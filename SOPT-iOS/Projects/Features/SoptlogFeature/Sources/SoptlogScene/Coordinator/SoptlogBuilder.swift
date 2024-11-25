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
    public init() {}
}

extension SoptlogBuilder: SoptlogFeatureBuildable {
    public func makeSoptlog() -> SoptlogPresentable {
        let viewModel = SoptlogViewModel()
        let soptlogVC = SoptlogVC(viewModel: viewModel)
        return (soptlogVC, viewModel)
    }
}
