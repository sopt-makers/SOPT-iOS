//
//  SendVerificationCodeEntity.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct SendVerificationCodeRequestEntity: Encodable {
    let name: String?
    let id: String? = nil
    let phone: String
    let type: VerifyEntityType
    
    public init(name: String?, phone: String, type: VerifyEntityType) {
        self.name = name
        self.phone = phone.filter{ $0.isNumber }
        self.type = type
    }
}
