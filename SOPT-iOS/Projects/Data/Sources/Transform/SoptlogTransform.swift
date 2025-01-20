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
        return SoptlogModel.init(userName: self.userName,
                                 profileImage: self.profileImage,
                                 part: self.part,
                                 soptampRank: self.soptampRank ?? "0",
                                 pokeCount: self.pokeCount,
                                 soptLevel: self.soptLevel,
                                 during: self.during ?? 0,
                                 profileMessage: self.profileMessage,
                                 icons: self.icons,
                                 isFortuneChecked: self.isFortuneChecked,
                                 todayFortuneText: self.todayFortuneText,
                                 isActive: self.isActive)
    }
}
