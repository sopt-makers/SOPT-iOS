//
//  ProfileListContentModel.swift
//  PokeFeature
//
//  Created by sejin on 12/8/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct ProfileListContentModel {
    let userId: String
    let avatarUrl: String
    let name: String
    let partInfomation: String
    let pokeCount: Int
    let relation: PokeRelation
}
