//
//  PokeUserEntity.swift
//  Networks
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - Empty
public struct PokeUserEntity: Codable {
    let userId: Int
    let profileImage, name: String
    let generation: Int
    let part: String
    let pokeNum: Int
    let message: String
    let relationName: String?
    let mutual: [String]
    let isFirstMeet, isAlreadyPoke: Bool
}
