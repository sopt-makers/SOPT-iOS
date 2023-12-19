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
    public let userId: Int
    public let profileImage, name: String
    public let generation: Int
    public let part: String
    public let pokeNum: Int
    public let message: String
    public let relationName: String
    public let mutual: [String]
    public let isFirstMeet, isAlreadyPoke: Bool
    
    public init(userId: Int, profileImage: String, name: String, generation: Int, part: String, pokeNum: Int, message: String, relationName: String, mutual: [String], isFirstMeet: Bool, isAlreadyPoke: Bool) {
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
