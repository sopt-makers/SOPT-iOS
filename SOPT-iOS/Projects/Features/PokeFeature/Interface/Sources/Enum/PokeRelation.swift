//
//  PokeRelation.swift
//  PokeFeature
//
//  Created by sejin on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public protocol ProfileRelation {
    
}

public enum PokeRelation: String {
    case nonFriend
    case newFriend = "친한친구"
    case bestFriend = "단짝친구"
    case soulmate = "천생연분"
}

extension PokeRelation {
    public var toEnglishName: String {
        switch self {
        case .nonFriend:
            return "nonFriend"
        case .newFriend:
            return "newFriend"
        case .bestFriend:
            return "bestFriend"
        case .soulmate:
            return "soulmate"
        }
    }
}
