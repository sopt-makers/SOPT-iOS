//
//  SoptlogEntity.swift
//  Networks
//
//  Created by 강윤서 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct SoptlogResponseEntity: Decodable {
    public let userName: String?
    public let profileImage: String?
    public let part: String
    public let soptampRank: String?
    public let pokeCount: String
    public let soptLevel: String
    public let during: String
    public let profileMessage: String
    public let icons: [String]
    public let isFortuneChecked: Bool
    public let todayFortuneText: String
    public let isActive: Bool
}
