//
//  DefaultPokeCoordinatorOutput.swift
//  PokeFeature
//
//  Created by Jae Hyun Lee on 6/3/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import BaseFeatureDependency

public protocol DefaultPokeCoordinatorOutput {
    func showPokeMain(isRouteFromRoot: Bool)
}

public typealias DefaultPokeCoordinator = DefaultPokeCoordinatorOutput & DefaultCoordinator
