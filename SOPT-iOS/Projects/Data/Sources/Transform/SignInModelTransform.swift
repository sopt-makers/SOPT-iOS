//
//  SignInModelTransform.swift
//  Data
//
//  Created by 장석우 on 7/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Networks
import Domain
import Core

extension SignInEntity {
    public func toDomain() -> SignInModel {
        SignInModel(
            tokens: LegacyTokensModel(
                accessToken: self.accessToken,
                refreshToken: self.refreshToken,
                playgroundToken: self.playgroundToken
            ),
            status: self.status.toDomain()
        )
    }
}

extension UserStatus {
    func toDomain() -> UserType {
        switch self {
        case .active: return .active
        case .inactive: return .inactive
        case .visitor: return .visitor
        }
    }
}
