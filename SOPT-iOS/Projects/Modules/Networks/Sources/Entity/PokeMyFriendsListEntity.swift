//
//  PokeMyFriendsListEntity.swift
//  Networks
//
//  Created by sejin on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeMyFriendsListEntity: Codable {
    public let friendList: [PokeUserEntity]
    public let totalSize: Int
    public let pageSize: Int
    public let pageNum: Int
}
