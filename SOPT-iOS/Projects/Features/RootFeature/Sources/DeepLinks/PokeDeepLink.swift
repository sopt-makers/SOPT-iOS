//
//  PokeDeepLink.swift
//  RootFeature
//
//  Created by sejin on 12/30/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import PokeFeature

public struct PokeDeepLink: DeepLinkExecutable {
    public let name = "poke"
    public let children: [DeepLinkExecutable] = [PokeNotificationListDeepLink()]
    
    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let coordinator = coordinator as? ApplicationCoordinator else { return nil }
        // 현재 Poke 메인 뷰로의 라우팅은 요구사항에 없지만 추후에 추가된다면 온보딩 뷰 대상 유저인지 파악이 필요해서 기획적인 논의가 필요
        return coordinator.makePokeCoordinator()
    }
}
