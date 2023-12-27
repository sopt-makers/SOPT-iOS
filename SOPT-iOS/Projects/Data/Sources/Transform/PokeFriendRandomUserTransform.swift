//
//  PokeFriendRandomUserTransform.swift
//  Data
//
//  Created by sejin on 12/20/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension PokeFriendRandomUserEntity {
    public func toDomain() -> PokeFriendRandomUserModel {
        return PokeFriendRandomUserModel(friendId: friendId,
                                         playgroundId: playgroundId,
                                         friendName: friendName,
                                         friendProfileImage: friendProfileImage,
                                         friendList: friendList.map { $0.toDomain() })
    }
}
