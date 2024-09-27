//
//  DailyFortuneTransform.swift
//  Data
//
//  Created by 강윤서 on 9/27/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension DailyFortuneResultEntity {
    public func toDomain() -> DailySoptuneResultModel {
        return DailySoptuneResultModel(userName: userName, title: title)
    }
}
