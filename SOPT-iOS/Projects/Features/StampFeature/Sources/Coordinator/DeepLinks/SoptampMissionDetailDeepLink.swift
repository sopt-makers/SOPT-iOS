//
//  SoptampMissionDetailDeepLink.swift
//  StampFeature
//
//  Created by 성현주 on 10/21/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import BaseFeatureDependency
import Core

public struct SoptampMissionDetailDeepLink: DeepLinkExecutable {
    public let name = "missionDetail"
    public let children: [DeepLinkExecutable] = []
    public var isDestination: Bool = true

    public init() {}

    public func execute(with coordinator: Coordinator, queryItems: [URLQueryItem]?) -> Coordinator? {
        guard let idString = queryItems?.getQueryValue(key: "missionId"),
              let missionId = Int(idString) else {
            return nil
        }

        guard let levelString = queryItems?.getQueryValue(key: "level"),
              let level = Int(levelString) else {
            return nil
        }

        guard let isMineString = queryItems?.getQueryValue(key: "isMine") else {
            return nil
        }
        let isMine = isMineString.lowercased() == "true"

        let nickname = isMine ? nil : queryItems?.getQueryValue(key: "nickname")

        switch Config.coordinatorFlag {
        case .legacy:
            guard let coordinator = coordinator as? LegacyStampCoordinator else {
                return nil
            }

        case .new:
            guard let coordinator = coordinator as? StampCoordinator else {
                return nil
            }
            coordinator.runMissionDetailById(missionId: missionId, level: level, username: nickname)
        }
        return coordinator
    }
}
