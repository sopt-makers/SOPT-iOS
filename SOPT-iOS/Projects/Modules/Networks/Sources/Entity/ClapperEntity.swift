//
//  ClapListEntity.swift
//  Networks
//
//  Created by 성현주 on 10/26/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct ClapperEntity: Decodable {
    public let nickname: String
    public let profileImageUrl: String
    public let profileMessage: String?
    public let clapCount: Int
}

public struct ClapListEntity: Decodable {
    public let users: [ClapperEntity]
}
