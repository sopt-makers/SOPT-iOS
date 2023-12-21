//
//  PokeRelation+.swift
//  PokeFeature
//
//  Created by sejin on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import UIKit

import DSKit
import Domain

public extension PokeRelation {
    var color: UIColor {
        switch self {
        case .nonFriend, .newFriend:
            return DSKitAsset.Colors.success.color
        case .bestFriend:
            return DSKitAsset.Colors.information.color
        case .soulmate:
            return DSKitAsset.Colors.secondary.color
        }
    }
}

public extension PokeUserModel {
    var pokeRelation: PokeRelation {
        return PokeRelation(rawValue: self.relationName) ?? .nonFriend
    }
}
