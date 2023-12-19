//
//  PokeUserTransform.swift
//  Data
//
//  Created by sejin on 12/19/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension PokeUserEntity {
    public func toDomain() -> PokeUserModel {
        return PokeUserModel(userId: userId, profileImage: profileImage, name: name, generation: generation, part: part, pokeNum: pokeNum, message: message, relationName: relationName, mutual: mutual, isFirstMeet: isFirstMeet, isAlreadyPoke: isAlreadyPoke)
    }
}
