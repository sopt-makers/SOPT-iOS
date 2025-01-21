//
//  CalendarDetailTrasform.swift
//  Data
//
//  Created by 강윤서 on 1/21/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension HomeCalendarDetailResponseEntity {
    public func toDomain() -> HomeCalendarDetailModel {
        return HomeCalendarDetailModel(
            date: self.date,
            title: self.title,
            type: self.type,
            isRecentSchedule: self.isRecentSchedule
        )
    }
}
