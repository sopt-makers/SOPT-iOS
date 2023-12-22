//
//  PokeMessagesModel.swift
//  Domain
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeMessagesModel: Decodable {
    public let messages: [PokeMessageModel]
}

public struct PokeMessageModel: Decodable {
    public let messageId: Int
    public let content: String
    
    public init(
        messageId: Int,
        content: String
    ) {
        self.messageId = messageId
        self.content = content
    }
}
