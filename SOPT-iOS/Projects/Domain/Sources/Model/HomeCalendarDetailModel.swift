//
//  HomeCalendarDetailModel.swift
//  Domain
//
//  Created by 강윤서 on 1/21/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeCalendarDetailModel {
    let date: String
    let title: String
    let type: String
    let isRecentSchedule: Bool
    
    public init(date: String, title: String, type: String, isRecentSchedule: Bool) {
        self.date = date
        self.title = title
        self.type = type
        self.isRecentSchedule = isRecentSchedule
    }
}
