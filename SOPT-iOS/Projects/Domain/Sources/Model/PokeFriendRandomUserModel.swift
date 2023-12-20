//
//  PokeFriendRandomUserModel.swift
//  Domain
//
//  Created by sejin on 12/20/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeFriendRandomUserModel {
    public let friendId: Int
    public let friendName, friendProfileImage: String
    public let friendList: [PokeUserModel]
    
    public init(friendId: Int, friendName: String, friendProfileImage: String, friendList: [PokeUserModel]) {
        self.friendId = friendId
        self.friendName = friendName
        self.friendProfileImage = friendProfileImage
        self.friendList = friendList
    }
}
