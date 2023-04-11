//
//  RankDetailEntity.swift
//  Network
//
//  Created by Junho Lee on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct RankDetailEntity: Codable {
    public let nickname: String
    public let profileMessage: String?
    public let userMissions: [UserMission]
}

public struct UserMission: Codable {
    public let id: Int
    public let title: String
    public let level: Int
    public let display: Bool
    public let profileImage: String?
}
