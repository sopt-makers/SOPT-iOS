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
    public let isAppjamParticipant: Bool

    /// 솝탬프 정보
    public let soptampCount: Int?
    public let viewCount: Int?
    public let myClapCount: Int?
    public let clapCount: Int?
    
    /// 콕찌르기 정보
    public let totalPokeCount: Int
    public let newFriendsPokeCount: Int
    public let bestFriendsPokeCount: Int
    public let soulmatesPokeCount: Int
    
    public init(
        isActive: Bool,
        isAppjamParticipant: Bool,
        soptampCount: Int?,
        viewCount: Int?,
        myClapCount: Int?,
        clapCount: Int?,
        totalPokeCount: Int,
        newFriendsPokeCount: Int,
        bestFriendsPokeCount: Int,
        soulmatesPokeCount: Int
    ) {
        self.isActive = isActive
        self.isAppjamParticipant = isAppjamParticipant
        self.soptampCount = soptampCount
        self.viewCount = viewCount
        self.myClapCount = myClapCount
        self.clapCount = clapCount
        self.totalPokeCount = totalPokeCount
        self.newFriendsPokeCount = newFriendsPokeCount
        self.bestFriendsPokeCount = bestFriendsPokeCount
        self.soulmatesPokeCount = soulmatesPokeCount
    }
}
