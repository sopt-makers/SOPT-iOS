//
//  SoptampPartMissionListDeepLink.swift
//  StampFeature
//
//  Created by 성현주 on 10/21/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Core

public struct SoptampPartMissionListDeepLink: DeepLinkExecutable {
    public let name = "missions"
    public let children: [DeepLinkExecutable] = [SoptampPartMissionDetailDeepLink()]
    public var isDestination: Bool = false 

    public init() {}

    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {

        guard let username = queryItems?.getQueryValue(key: "nickname"), !username.isEmpty else {
            return nil
        }

        let sentence = queryItems?.getQueryValue(key: "sentence") ?? ""

        switch Config.coordinatorFlag {
        case .legacy:
            guard let coordinator = coordinator as? LegacyStampCoordinator else { return nil }
        case .new:
            guard let coordinator = coordinator as? StampCoordinator else { return nil }
            coordinator.runOtherMissionList(username: username, sentence: sentence)
        }
        return coordinator
    }
}
