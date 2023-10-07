//
//  RankingEntity.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct RankingEntity: Codable {
    public let rank: Int
    public let nickname: String
    public let point: Int
    public let profileMessage: String?

    enum CodingKeys: String, CodingKey {
        case rank
        case nickname, point, profileMessage
    }
}
