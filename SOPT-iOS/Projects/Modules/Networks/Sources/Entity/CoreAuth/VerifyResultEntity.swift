//
//  VerifyResultEntity.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct VerifyResultEntity: Decodable {
    let isVerified: Bool
    let name: String
    let phone: String
    
    public init(isVerified: Bool, name: String, phone: String) {
        self.isVerified = isVerified
        self.name = name
        self.phone = phone
    }
}
