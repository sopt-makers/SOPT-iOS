//
//  HomeAppServiceAccessStatusEntity.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - Entity

public struct HomeAppServiceAccessStatusEntity: Codable {
    public let serviceName: String
    public let displayAlarmBadge: Bool
    public let alarmBadge, deepLink: String
    public let iconURL: String?

    enum CodingKeys: String, CodingKey {
        case serviceName, displayAlarmBadge, alarmBadge
        case iconURL = "iconUrl"
        case deepLink
    }
}
