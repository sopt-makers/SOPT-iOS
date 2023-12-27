//
//  PokeMessagesModel.swift
//  Domain
//
//  Created by Ian on 12/22/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

public struct PokeMessagesModel: Decodable {
    public let header: String
    public let messages: [PokeMessageModel]
    
    public init(header: String, messages: [PokeMessageModel]) {
        self.header = header
        self.messages = messages
    }
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
