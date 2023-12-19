//
//  PokeUserModel.swift
//  Domain
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

// MARK: - Empty
public struct PokeUserModel: Codable {
    let userId: Int
    let profileImage, name: String
    let generation: Int
    let part: String
    let pokeNum: Int
    let message: String
    let relationName: String?
    let mutual: [String]
    let isFirstMeet, isAlreadyPoke: Bool
    
    public init(userId: Int, profileImage: String, name: String, generation: Int, part: String, pokeNum: Int, message: String, relationName: String?, mutual: [String], isFirstMeet: Bool, isAlreadyPoke: Bool) {
        self.userId = userId
        self.profileImage = profileImage
        self.name = name
        self.generation = generation
        self.part = part
        self.pokeNum = pokeNum
        self.message = message
        self.relationName = relationName
        self.mutual = mutual
        self.isFirstMeet = isFirstMeet
        self.isAlreadyPoke = isAlreadyPoke
    }
}
