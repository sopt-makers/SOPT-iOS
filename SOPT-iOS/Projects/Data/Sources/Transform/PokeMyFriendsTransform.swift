//
//  PokeMyFriendsTransform.swift
//  Data
//
//  Created by sejin on 12/21/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension PokeMyFriendsEntity {
    public func toDomain() -> PokeMyFriendsModel {
        return PokeMyFriendsModel(newFriend: newFriend.map { $0.toDomain() },
                                  newFriendSize: newFriendSize,
                                  bestFriend: bestFriend.map { $0.toDomain() },
                                  bestFriendSize: bestFriendSize,
                                  soulmate: soulmate.map { $0.toDomain() },
                                  soulmateSize: soulmateSize)
    }
}
