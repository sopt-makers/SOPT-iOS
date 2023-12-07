//
//  PokeBuilder.swift
//  PokeFeatureInterface
//
//  Created by sejin on 12/7/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Core
import Domain
@_exported import PokeFeatureInterface

public final class PokeBuilder {
    public init() {}
}

extension PokeBuilder: PokeFeatureBuildable {
    public func makePokeMainVC() -> PokeFeatureInterface.PokeMainViewControllable {
        let viewModel = PokeMainViewModel()
        let pokeMainVC = PokeMainVC(viewModel: viewModel)
        return pokeMainVC
    }
}
