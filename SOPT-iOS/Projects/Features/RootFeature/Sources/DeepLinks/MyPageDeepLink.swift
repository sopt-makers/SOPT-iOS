//
//  MyPageDeepLink.swift
//  RootFeature
//
//  Created by sejin on 2023/10/28.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import BaseFeatureDependency

public struct MyPageDeepLink: DeepLinkExecutable {
    public let name = "mypage"
    public let children: [DeepLinkExecutable] = [SoptlogDeepLink()]
    public var isDestination: Bool = false

    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }

        coordinator.runTabBarFlow(initSelectedTabType: .mypage)

        return coordinator
    }
}
