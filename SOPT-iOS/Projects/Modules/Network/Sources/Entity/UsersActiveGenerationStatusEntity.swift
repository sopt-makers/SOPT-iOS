//
//  UsersActiveGenerationStatusEntity.swift
//  Network
//
//  Created by Ian on 9/20/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

public struct UsersActiveGenerationStatusEntity {
    public let currentGeneration: Int
    public let status: UsersActivationState
}

extension UsersActiveGenerationStatusEntity: Decodable {
    enum CodingKeys: String, CodingKey {
        case currentGeneration, status
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.currentGeneration = (try? container.decode(Int.self, forKey: .currentGeneration)) ?? 0
        self.status = (try? container.decode(UsersActivationState.self, forKey: .status)) ?? .INACTIVE
    }
}

public enum UsersActivationState: String, Decodable {
    case ACTIVE
    case INACTIVE
}
