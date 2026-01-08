//
//  AppjamMissionListEntity.swift
//  Networks
//
//  Created by 최주리 on 1/9/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

public struct AppjamMissionListEntity: Codable {
    public let myTeamNumber: String
    public let teamNumber: String
    public let teamName: String
    public let missions: MissionListEntity
    public let isAppjamJoined: Bool
}
