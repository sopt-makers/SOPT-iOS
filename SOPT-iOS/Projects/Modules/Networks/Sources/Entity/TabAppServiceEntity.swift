//
//  TabAppServiceEntity.swift
//  Networks
//
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - Entity

public struct TabAppServiceEntity: Codable {
    public let serviceName: String
    public let displayAlarmBadge: Bool
    public let alarmBadge: String
    public let iconURL, deepLink: String

    enum CodingKeys: String, CodingKey {
        case serviceName, displayAlarmBadge, alarmBadge
        case iconURL = "iconUrl"
        case deepLink
    }
}
