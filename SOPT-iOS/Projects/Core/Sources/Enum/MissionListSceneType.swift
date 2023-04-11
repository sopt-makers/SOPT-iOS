//
//  MissionListSceneType.swift
//  Core
//
//  Created by 김영인 on 2023/03/17.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

@frozen
public enum MissionListSceneType {
    case `default`
    case ranking(userName: String, sentence: String)
    
    var isRankingView: Bool {
        switch self {
        case .default: return false
        case .ranking: return true
        }
    }
}
