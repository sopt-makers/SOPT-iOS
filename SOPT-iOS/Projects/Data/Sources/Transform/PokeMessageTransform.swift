//
//  PokeMessageTransform.swift
//  Data
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Domain

import Networks

extension PokeMessageEntity {
    public func toDomain() -> PokeMessageModel {
        return PokeMessageModel(
            messageId: self.messageId,
            content: self.content
        )
    }
}
