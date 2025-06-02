//
//  RankingViewType.swift
//  StampFeature
//
//  Created by Jae Hyun Lee on 6/2/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Domain

public enum RankingViewType {
    case all
    case currentGeneration(info: UsersActiveGenerationStatusViewResponse)
    case partRanking
    case individualRankingInPart(part: Part)
}
