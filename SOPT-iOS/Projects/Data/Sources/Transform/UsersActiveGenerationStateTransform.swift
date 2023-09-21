//
//  UsersActiveGenerationStatusTransform.swift
//  Data
//
//  Created by Ian on 9/20/23.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Domain
import Network

extension UsersActiveGenerationStatusEntity {
    func toDomain() -> UsersActiveGenerationStatusViewResponse {
        .init(
            currentGeneration: self.currentGeneration,
            status: self.status.toDomain()
        )
    }
}

extension Network.UsersActivationState {
    func toDomain() -> Domain.UsersActivationState {
        switch self {
        case .ACTIVE: return .ACTIVE
        case .INACTIVE: return .INACTIVE
        }
    }
}
