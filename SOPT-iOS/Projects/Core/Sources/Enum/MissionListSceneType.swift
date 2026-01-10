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
    case appJamTeam(teamName: String, teamNumber: String)
    
    public var isRankingView: Bool {
        switch self {
        case .default: return false
        case .ranking, .appJamTeam: return true
        }
    }
    
    public var usrename: String? {
        switch self {
        case .default: return nil
        case .ranking(let username, _):
            return username
        case .appJamTeam:
            return nil
        }
    }
    
    public var isAppJamTeamView: Bool {
        switch self {
        case .appJamTeam: return true
        default: return false
        }
    }
    
    public var teamName: String? {
        switch self {
        case .appJamTeam(let teamName, _):
            return teamName
        default:
            return nil
        }
    }
    
    public var teamNumber: String? {
        switch self {
        case .appJamTeam(_, let teamNumber):
            return teamNumber
        default:
            return nil
        }
    }
}
