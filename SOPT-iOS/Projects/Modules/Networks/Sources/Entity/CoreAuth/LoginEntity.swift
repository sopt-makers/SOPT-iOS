//
//  LoginEntity.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct LoginEntity: Encodable {
    let code: String
    let authPlatform: PlatformType
    
    public init(code: String, authPlatform: PlatformType) {
        self.code = code
        self.authPlatform = authPlatform
    }
}
