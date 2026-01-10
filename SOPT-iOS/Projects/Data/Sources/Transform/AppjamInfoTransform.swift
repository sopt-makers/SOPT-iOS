//
//  AppjamInfoTransform.swift
//  Data
//
//  Created by Jae Hyun Lee on 1/9/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension AppjamInfoEntity {
    public func toDomain() -> AppjamInfoModel {
        return AppjamInfoModel(
            teamNumber: self.teamNumber,
            teamName: self.teamName,
            isAppjamJoined: self.isAppjamJoined
        )
    }
}

