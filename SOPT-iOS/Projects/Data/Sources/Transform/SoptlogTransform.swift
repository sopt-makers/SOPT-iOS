//
//  SoptlogTransform.swift
//  Data
//
//  Created by 강윤서 on 1/19/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension SoptlogResponseEntity {
    public func toDomain() -> SoptlogModel {
        return SoptlogModel(
            isActive: self.isActive,
            isFortuneChecked: self.isFortuneChecked,
            todayFortuneText: self.todayFortuneText,
            soptampCount: self.soptampCount,
            viewCount: self.viewCount,
            myClapCount: self.myClapCount,
            totalPokeCount: self.totalPokeCount,
            newFriendsPokeCount: self.newFriendsPokeCount,
            bestFriendsPokeCount: self.bestFriendsPokeCount,
            soulmatesPokeCount: self.soulmatesPokeCount
        )
    }
}
