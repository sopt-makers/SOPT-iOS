//
//  RankingListTappable.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/22.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Domain

protocol RankingListTappable {
    func getModelItem() -> RankingListTapItem?
}

public struct RankingListTapItem {
    public let username: String
    public let sentence: String
    public let userId: Int
}

extension RankingModel {
    func toRankingListTapItem() -> RankingListTapItem {
        .init(username: self.username,
              sentence: self.sentence,
              userId: self.userId)
    }
}
