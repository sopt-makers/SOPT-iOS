//
//  SoptlogCoordinatorDestination.swift
//  SoptlogFeatureInterface
//
//  Created by Jae Hyun Lee on 5/6/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import PokeFeatureInterface

public enum SoptlogCoordinatorDestination {
//    case dailySoptune
    case webLink(url: String)
    case soptamp
    case pokeHome
    case pokeMyFriends(relation: PokeRelation)
    case home
    case signIn
}
