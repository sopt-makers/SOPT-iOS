//
//  PokeMyFriendsEntity.swift
//  Networks
//
//  Created by sejin on 12/21/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeMyFriendsEntity: Codable {
    public let newFriend: [PokeUserEntity]
    public let newFriendSize: Int
    public let bestFriend: [PokeUserEntity]
    public let bestFriendSize: Int
    public let soulmate: [PokeUserEntity]
    public let soulmateSize: Int
}
