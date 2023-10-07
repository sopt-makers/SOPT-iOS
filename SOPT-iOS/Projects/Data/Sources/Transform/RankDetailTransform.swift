//
//  RankDetailTransform.swift
//  Data
//
//  Created by Junho Lee on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Core
import Domain
import Networks

extension RankDetailEntity {
    
    public func toDomain() -> [MissionListModel] {
        return self.userMissions
            .map { $0.toMissionListModel() }
    }
}

extension UserMission {
    public func toMissionListModel() -> MissionListModel {
        return .init(
            id: self.id,
            title: self.title,
            level: self.level,
            isCompleted: true
        )
    }
}

