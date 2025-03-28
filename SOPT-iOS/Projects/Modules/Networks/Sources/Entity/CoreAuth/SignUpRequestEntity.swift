//
//  SignUpEntity.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct SignUpRequestEntity: Encodable {
    let name: String?
    let phone: String
    let code: String
    let authPlatform: PlatformType
    
    public init(name: String?, phone: String, code: String, authPlatform: PlatformType) {
        self.name = name
        self.phone = phone
        self.code = code
        self.authPlatform = authPlatform
    }
}
