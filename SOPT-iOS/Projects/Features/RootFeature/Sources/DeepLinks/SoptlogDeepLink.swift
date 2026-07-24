//
//  SoptlogDeepLink.swift
//  RootFeature
//
//  Created by Jae Hyun Lee on 5/24/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency

public struct SoptlogDeepLink: DeepLinkExecutable {
    public let name = "soptlog"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = false

    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }

        coordinator.pushSoptlogInMyPageTab()

        return coordinator
    }
}
