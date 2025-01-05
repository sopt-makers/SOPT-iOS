//
//  SendVerificationCodeEntity.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct SendVerificationCodeEntity: Encodable {
    let name: String
    let phone: String
    let type: VerifyType
    
    public init(name: String, phone: String, type: VerifyType) {
        self.name = name
        self.phone = phone.filter{ $0.isNumber }
        self.type = type
    }
}
