//
//  VerifyCodeEntity.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct VerifyCodeRequestEntity: Encodable {
    public let name: String?
    public let phone: String
    public let type: VerifyEntityType
    public let code: String
    
    public init(name: String?, phone: String, type: VerifyEntityType, code: String) {
        self.name = name
        self.phone = phone
        self.type = type
        self.code = code
    }
}
