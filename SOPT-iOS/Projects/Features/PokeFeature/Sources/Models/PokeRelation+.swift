//
//  PokeRelation+.swift
//  PokeFeature
//
//  Created by sejin on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import MDS
import DSKit
import Domain
import Core

public extension PokeRelation {
    var color: UIColor {
        switch self {
        case .nonFriend, .newFriend:
            return SemanticColor.Stroke.Secondary.default
            // TODO: - MDS 반영 후 적용
        case .bestFriend:
            return DSKitAsset.Colors.information.color
        case .soulmate:
            return SemanticColor.Stroke.Brand.default
        }
    }
    
    var title: String {
        switch self {
        case .newFriend:
            return I18N.Poke.MyFriends.newFriends
        case .bestFriend:
            return I18N.Poke.MyFriends.bestFriend
        case .soulmate:
            return I18N.Poke.MyFriends.soulmate
        default:
            return ""
        }
    }
    
    var friendBaselineDescription: String {
        switch self {
        case .newFriend:
            return I18N.Poke.MyFriends.friendsBaseline(2)
        case .bestFriend:
            return I18N.Poke.MyFriends.friendsBaseline(5)
        case .soulmate:
            return I18N.Poke.MyFriends.friendsBaseline(11)
        default:
            return ""
        }
    }
    
    var queryValueName: String {
        switch self {
        case .newFriend:
            return "new"
        case .bestFriend:
            return "bestfriend"
        case .soulmate:
            return "soulmate"
        default:
            return ""
        }
    }
}

public extension PokeUserModel {
    var pokeRelation: PokeRelation {
        return PokeRelation(rawValue: self.relationName) ?? .nonFriend
    }
}
