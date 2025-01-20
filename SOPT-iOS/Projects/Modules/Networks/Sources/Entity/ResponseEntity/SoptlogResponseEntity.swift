//
//  SoptlogEntity.swift
//  Networks
//
//  Created by 강윤서 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - 한 줄 소개와 솝마디 추가되어야 함. 파트 방식 변경 요청 상태.
public struct SoptlogResponseEntity: Decodable {
    public let userName: String
    public let profileImage: String
    public let part: String
    public let soptampRank: String?
    public let pokeCount: String
    public let soptLevel: String
    public let during: Int?
    public let profileMessage: String
    public let icons: [String]
    public let isFortuneChecked: Bool
    public let todayFortuneText: String
    public let isActive: Bool
    
    public init(userName: String, profileImage: String, part: String, soptampRank: String?, pokeCount: String, soptLevel: String, during: Int?, profileMessage: String, icons: [String], isFortuneChecked: Bool, todayFortuneText: String, isActive: Bool) {
        self.userName = userName
        self.profileImage = profileImage
        self.part = part
        self.soptampRank = soptampRank
        self.pokeCount = pokeCount
        self.soptLevel = soptLevel
        self.during = during
        self.profileMessage = profileMessage
        self.icons = icons
        self.isFortuneChecked = isFortuneChecked
        self.todayFortuneText = todayFortuneText
        self.isActive = isActive
    }
}
