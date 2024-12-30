//
//  VerifyCodeEntity.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct VerifyCodeEntity: Encodable {
    let name: String
    let phone: String
    let type: VerifyType
    let code: String
    
    public init(name: String, phone: String, type: VerifyType, code: String) {
        self.name = name
        self.phone = phone
        self.type = type
        self.code = code
    }
}
