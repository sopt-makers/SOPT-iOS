//
//  AuthTokensModel.swift
//  Domain
//
//  Created by 장석우 on 7/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation
import Core

public struct LegacyTokensModel: AuthTokens {
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
