//
//  ClapListModel.swift
//  Domain
//
//  Created by 성현주 on 10/22/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct ClapperModel: Hashable {
    public let nickname: String
    public let profileImageUrl: String
    public let profileMessage: String
    public let clapCount: Int

    public init(nickname: String, profileImageUrl: String, profileMessage: String, clapCount: Int) {
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.profileMessage = profileMessage
        self.clapCount = clapCount
    }
}

public struct ClapListModel: Hashable {
    public let users: [ClapperModel]

    public init(users: [ClapperModel]) {
        self.users = users
    }
}
