//
//  LoginTransform.swift
//  Data
//
//  Created by 장석우 on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension CoreLoginRequestEntity {
    static func dto(token: String, oauthType: OAuthType) -> Self {
        var platform: PlatformType
        
        switch oauthType {
        case .apple: platform = .apple
        case .google: platform = .google
        }
        
        return .init(token: token, authPlatform: platform)
    }
}

extension CoreLoginEntity {
    public func toDomain() -> CoreAuthTokens {
        .init(accessToken: accessToken, refreshToken: refreshToken)
    }
}
