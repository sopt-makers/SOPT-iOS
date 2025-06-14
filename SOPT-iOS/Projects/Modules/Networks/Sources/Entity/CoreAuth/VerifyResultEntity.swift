//
//  VerifyResultEntity.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct VerifyResultEntity: Decodable {
    public let name: String?
    public let phone: String
    
    public init(name: String?, phone: String) {
        self.name = name
        self.phone = phone
    }
}
