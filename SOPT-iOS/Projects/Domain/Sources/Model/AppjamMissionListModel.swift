//
//  AppjamMissionListModel.swift
//  Domain
//
//  Created by 최주리 on 1/9/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AppjamMissionListModel {
    public let myTeamNumber: String
    public let teamNumber: String
    public let teamName: String
    public let missions: [MissionListModel]
    public let isAppjamJoined: Bool
    
    public init(
        myTeamNumber: String,
        teamNumber: String,
        teamName: String,
        missions: [MissionListModel],
        isAppjamJoined: Bool
    ) {
        self.myTeamNumber = myTeamNumber
        self.teamNumber = teamNumber
        self.teamName = teamName
        self.missions = missions
        self.isAppjamJoined = isAppjamJoined
    }
}
