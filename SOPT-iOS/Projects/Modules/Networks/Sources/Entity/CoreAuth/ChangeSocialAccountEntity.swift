//
//  ChangeSocialAccountEntity.swift
//  Networks
//
//  Created by 장석우 on 12/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct ChangeSocialAccountEntity: Encodable {
    let phone: String
    let authPlatform: PlatformType
    let code: String

    public init(phone: String, authPlatform: PlatformType, code: String) {
        self.phone = phone
        self.authPlatform = authPlatform
        self.code = code
    }
    
}


public extension ChangeSocialAccountEntity {
    static let stub: ChangeSocialAccountEntity = .init(phone: "01011111111", authPlatform: .apple, code: "code")
}
