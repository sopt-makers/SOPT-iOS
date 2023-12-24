//
//  PokeMyFriendsModel.swift
//  Domain
//
//  Created by sejin on 12/21/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeMyFriendsModel {
    public var newFriend: [PokeUserModel]
    public let newFriendSize: Int
    public var bestFriend: [PokeUserModel]
    public let bestFriendSize: Int
    public var soulmate: [PokeUserModel]
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

extension PokeMyFriendsModel {
    public func replaceUser(newUserModel: PokeUserModel) -> PokeMyFriendsModel? {
        let friends = [newFriend, bestFriend, soulmate].map {
            $0.map { $0.userId != newUserModel.userId ? $0 : newUserModel }
        }

        guard friends.count == 3 else { return nil }
        
        return .init(newFriend: friends[0],
                     newFriendSize: newFriendSize,
                     bestFriend: friends[1],
                     bestFriendSize: bestFriendSize,
                     soulmate: friends[2],
                     soulmateSize: soulmateSize)
    }
}
