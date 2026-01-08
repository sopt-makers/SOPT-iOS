//
//  AppjamMissionListEntity.swift
//  Data
//
//  Created by 최주리 on 1/9/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

public extension AppjamMissionListEntity {
    func toDomain() -> AppjamMissionListModel {
        return .init(
            myTeamNumber: self.myTeamNumber,
            teamNumber: self.teamNumber,
            teamName: self.teamName,
            missions: self.missions.toDomain(),
            isAppjamJoined: self.isAppjamJoined
        )
    }
}
