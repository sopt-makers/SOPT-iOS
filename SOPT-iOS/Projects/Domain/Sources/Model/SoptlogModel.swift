//
//  SoptlogModel.swift
//  Domain
//
//  Created by 강윤서 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct  SoptlogModel {
    public let isActive: Bool
    
    /// 솝마디 상태
    public let isFortuneChecked: Bool
    public let todayFortuneText: String
    
    /// 솝탬프 정보
    public let soptampCount: Int
    public let viewCount: Int
    public let myClapCount: Int
    
    /// 콕찌르기 정보
    public let totalPokeCount: Int
    public let newFriendsPokeCount: Int
    public let bestFriendsPokeCount: Int
    public let soulmatesPokeCount: Int
    
    public init(
        isActive: Bool,
        isFortuneChecked: Bool,
        todayFortuneText: String,
        soptampCount: Int,
        viewCount: Int,
        myClapCount: Int,
        totalPokeCount: Int,
        newFriendsPokeCount: Int,
        bestFriendsPokeCount: Int,
        soulmatesPokeCount: Int
    ) {
        self.isActive = isActive
        self.isFortuneChecked = isFortuneChecked
        self.todayFortuneText = todayFortuneText
        self.soptampCount = soptampCount
        self.viewCount = viewCount
        self.myClapCount = myClapCount
        self.totalPokeCount = totalPokeCount
        self.newFriendsPokeCount = newFriendsPokeCount
        self.bestFriendsPokeCount = bestFriendsPokeCount
        self.soulmatesPokeCount = soulmatesPokeCount
    }
}
