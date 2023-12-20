//
//  PokeRelation.swift
//  PokeFeature
//
//  Created by sejin on 12/3/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit
import DSKit
import Domain

public enum PokeRelation: String {
    case newFriend = "친한친구"
    case bestFriend = "단짝친구"
    case soulmate = "천생연분"
}

extension PokeRelation {
    var color: UIColor {
        switch self {
        case .newFriend:
            return DSKitAsset.Colors.success.color
        case .bestFriend:
            return DSKitAsset.Colors.information.color
        case .soulmate:
            return DSKitAsset.Colors.secondary.color
        }
    }
}

extension PokeUserModel {
    var pokeRelation: PokeRelation {
        return PokeRelation(rawValue: self.relationName) ?? .newFriend
    }
}
