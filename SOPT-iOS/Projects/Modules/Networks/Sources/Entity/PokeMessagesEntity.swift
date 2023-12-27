//
//  PokeMessagesEntity.swift
//  Networks
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeMessagesEntity: Decodable {
    public let header: String
    public let messages: [PokeMessageEntity]
}

public struct PokeMessageEntity: Decodable {
    public let messageId: Int
    public let content: String
}
