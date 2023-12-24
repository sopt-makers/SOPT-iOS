//
//  PokeMyFriendsListModel.swift
//  Domain
//
//  Created by sejin on 12/23/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeMyFriendsListModel {
    public let friendList: [PokeUserModel]
    public let totalSize: Int
    public let pageSize: Int
    public let pageNum: Int
    
    public init(friendList: [PokeUserModel], totalSize: Int, pageSize: Int, pageNum: Int) {
        self.friendList = friendList
        self.totalSize = totalSize
        self.pageSize = pageSize
        self.pageNum = pageNum
    }
}

