//
//  LoginEntity.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct CoreLoginRequestEntity: Encodable {
    let token: String
    let authPlatform: PlatformType
    
    public init(token: String, authPlatform: PlatformType) {
        self.token = token
        self.authPlatform = authPlatform
    }
}
