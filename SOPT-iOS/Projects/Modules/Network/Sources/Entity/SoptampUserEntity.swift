//
//  SoptampUserEntity.swift
//  Network
//
//  Created by Junho Lee on 2023/04/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct SoptampUserEntity: Codable {
    public let nickname: String
    public let profileMessage: String?
    public let points: Int
    
    public init(nickname: String, profileMessage: String?, points: Int) {
        self.nickname = nickname
        self.profileMessage = profileMessage
        self.points = points
    }
}
