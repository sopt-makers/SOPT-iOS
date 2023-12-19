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
    public let userId: Int
    public let profileImage, name: String
    public let generation: Int
    public let part: String
    public let pokeNum: Int
    public let message: String
    public let relationName: String
    public let mutual: [String]
    public let isFirstMeet, isAlreadyPoke: Bool
}
