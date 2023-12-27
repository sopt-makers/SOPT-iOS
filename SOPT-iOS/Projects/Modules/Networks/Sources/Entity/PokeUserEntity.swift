//
//  PokeUserEntity.swift
//  Networks
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeUserEntity {
    public let userId: Int
    public let playgroundId: Int
    public let profileImage: String
    public let name: String
    public let generation: Int
    public let part: String
    public let pokeNum: Int
    public let message: String
    public let relationName: String
    public let mutualRelationMessage: String
    public let isFirstMeet, isAlreadyPoke: Bool
}

extension PokeUserEntity: Codable {
    public enum CodingKeys: CodingKey {
        case userId, playgroundId, profileImage, name, generation, part, pokeNum,
         message, relationName, mutualRelationMessage, isFirstMeet, isAlreadyPoke
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.playgroundId = try container.decode(Int.self, forKey: .playgroundId)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
        self.name = try container.decode(String.self, forKey: .name)
        self.generation = try container.decode(Int.self, forKey: .generation)
        self.part = try container.decode(String.self, forKey: .part)
        self.pokeNum = try container.decode(Int.self, forKey: .pokeNum)
        self.message = try container.decode(String.self, forKey: .message)
        self.relationName = try container.decode(String.self, forKey: .relationName)
        self.mutualRelationMessage = try container.decode(String.self, forKey: .mutualRelationMessage)
        self.isFirstMeet = try container.decode(Bool.self, forKey: .isFirstMeet)
        self.isAlreadyPoke = try container.decode(Bool.self, forKey: .isAlreadyPoke)
    }
}
