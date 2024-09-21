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
    public init() {}
}

extension DailySoptuneBuilder: DailySoptuneFeatureBuildable {
    public func makeDailySoptuneResultVC() -> any DailySoptuneFeatureInterface.DailySoptuneResultViewControllable {
        let viewModel = DailySoptuneResultViewModel()
        let dailySoptuneResultVC = DailySoptuneResultVC(viewModel: viewModel)
        return dailySoptuneResultVC
    }
}
