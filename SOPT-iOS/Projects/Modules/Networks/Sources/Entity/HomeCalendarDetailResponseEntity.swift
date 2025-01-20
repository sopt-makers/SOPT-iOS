//
//  HomeCalendarDetailResponseEntity.swift
//  Networks
//
//  Created by 강윤서 on 1/21/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct HomeCalendarDetailResponseEntity: Decodable {
    public let date: String
    public let title: String
    public let type: String
    public let isRecentSchedule: Bool
}
