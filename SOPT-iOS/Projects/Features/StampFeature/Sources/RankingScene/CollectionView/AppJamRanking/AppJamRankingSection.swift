//
//  AppJamRankingSection.swift
//  StampFeature
//
//  Created by 강윤서 on 12/16/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

enum AppJamRankingSection: Int, CaseIterable {
    case missionCards = 0
    case ranking = 1
}

enum AppJamRankingItem: Hashable, Sendable {
    case mission(AppJamRankRecentPresentationModel)
    case ranking(AppJamRankTodayPresentationModel)
}
