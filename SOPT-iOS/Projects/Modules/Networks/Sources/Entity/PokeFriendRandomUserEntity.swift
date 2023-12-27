//
//  PokeFriendRandomUserEntity.swift
//  Networks
//
//  Created by sejin on 12/20/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeFriendRandomUserEntity: Codable {
    public let friendId: Int
    public let playgroundId: Int
    public let friendName, friendProfileImage: String
    public let friendList: [PokeUserEntity]
}
