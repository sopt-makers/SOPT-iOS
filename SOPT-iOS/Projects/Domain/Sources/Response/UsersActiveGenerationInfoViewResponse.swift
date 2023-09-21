//
//  UsersActiveGenerationStatusViewResponse.swift
//  Domain
//
//  Created by Ian on 9/20/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

public struct UsersActiveGenerationStatusViewResponse: Equatable {
    public let currentGeneration: Int
    public let status: UsersActivationState
    
    public init(
        currentGeneration: Int,
        status: UsersActivationState
    ) {
        self.currentGeneration = currentGeneration
        self.status = status
    }
}

public enum UsersActivationState: String, Decodable {
    case ACTIVE
    case INACTIVE
}
