//
//  Rankingtransform.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Core
import Domain
import Network

extension RankingEntity {
    
    public func toDomain() -> RankingModel {
        return .init(username: self.nickname,
                     usreId: self.userID,
                     score: self.point,
                     sentence: self.profileMessage ?? I18N.RankingList.noSentenceText)
    }
}
