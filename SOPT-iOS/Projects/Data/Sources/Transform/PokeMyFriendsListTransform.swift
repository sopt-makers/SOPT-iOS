//
//  PokeMyFriendsListTransform.swift
//  Data
//
//  Created by sejin on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension PokeMyFriendsListEntity {
    public func toDomain() -> PokeMyFriendsListModel {
        return PokeMyFriendsListModel(friendList: friendList.map { $0.toDomain() }, totalSize: totalSize, pageSize: pageSize, pageNum: pageNum)
    }
}
