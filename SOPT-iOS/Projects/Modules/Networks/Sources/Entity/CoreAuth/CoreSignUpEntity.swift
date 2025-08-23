//
//  CoreSignUpEntity.swift
//  Networks
//
//  Created by 장석우 on 3/27/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public struct CoreSignUpRequestEntity: Encodable {
    let phone: String
    let token: String
    let authPlatform: PlatformType
    
    public init(
        phone: String,
        token: String,
        authPlatform: PlatformType
    ) {
        self.phone = phone
        self.token = token
        self.authPlatform = authPlatform
    }
}

