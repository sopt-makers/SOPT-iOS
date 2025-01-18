//
//  HomeRecentScheduleTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension CalendarRecentEntity {
    public func toDomain() -> HomeRecentScheduleModel {
        return HomeRecentScheduleModel(date: date, type: type, title: title)
    }
}
