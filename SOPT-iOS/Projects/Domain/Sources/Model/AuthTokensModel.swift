//
//  AuthTokensModel.swift
//  Domain
//
//  Created by 장석우 on 7/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Core

public struct LegacyAuthTokensModel: AuthTokens {
    public let accessToken: String
    public let refreshToken: String
    public let playgroundToken: String
    
    public init(
        accessToken: String,
        refreshToken: String,
        playgroundToken: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.playgroundToken = playgroundToken
    }
}

public struct AuthTokensModel {
    public let accessToken: String
    public let refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

extension AuthTokensModel: AuthTokens { }
