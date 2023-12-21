//
//  PokeMyFriendsModel.swift
//  Domain
//
//  Created by sejin on 12/21/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeMyFriendsModel {
    public let newFriend: [PokeUserModel]
    public let newFriendSize: Int
    public let bestFriend: [PokeUserModel]
    public let bestFriendSize: Int
    public let soulmate: [PokeUserModel]
    public let soulmateSize: Int
    
    public init(newFriend: [PokeUserModel], newFriendSize: Int, bestFriend: [PokeUserModel], bestFriendSize: Int, soulmate: [PokeUserModel], soulmateSize: Int) {
        self.newFriend = newFriend
        self.newFriendSize = newFriendSize
        self.bestFriend = bestFriend
        self.bestFriendSize = bestFriendSize
        self.soulmate = soulmate
        self.soulmateSize = soulmateSize
    }
}
