//
//  HomeAppServicesModel.swift
//  Domain
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeAppServicesModel: Codable {
    public var serviceName: String
    public var displayAlarmBadge: Bool
    public var alarmBadge, deepLink: String
    public var iconURL: String?
    
    public init(serviceName: String, displayAlarmBadge: Bool, alarmBadge: String, iconURL: String?, deepLink: String) {
        self.serviceName = serviceName
        self.displayAlarmBadge = displayAlarmBadge
        self.alarmBadge = alarmBadge
        self.iconURL = iconURL
        self.deepLink = deepLink
    }
}
