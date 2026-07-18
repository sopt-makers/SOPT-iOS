//
//  HomeAppServicesTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomeAppServiceAccessStatusEntity {
    public func toDomain() -> HomeAppServicesModel {
        return HomeAppServicesModel(serviceName: serviceName,
                                    displayAlarmBadge: displayAlarmBadge,
                                    alarmBadge: alarmBadge,
                                    iconURL: iconURL,
                                    deepLink: deepLink)
    }
}

extension TabAppServiceEntity {
    public func toDomain() -> HomeAppServicesModel {
        return HomeAppServicesModel(serviceName: serviceName,
                                    displayAlarmBadge: displayAlarmBadge,
                                    alarmBadge: alarmBadge,
                                    iconURL: iconURL,
                                    deepLink: deepLink)
    }
}
