//
//  ChangeSocialAccountEntity.swift
//  Networks
//
//  Created by 장석우 on 12/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

struct ChangeSocialAccountEntity: Encodable {
    let phone: String
    let authPlatform: SocialAccountType
    let code: String
    

    enum CodingKeys: CodingKey {
        case phone
        case authPlatform
        case code
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.phone, forKey: .phone)
        try container.encode(self.authPlatform.rawValue, forKey: .authPlatform)
        try container.encode(self.code, forKey: .code)
    }
    
}

enum SocialAccountType: String, Encodable {
    case google = "GOOGLE"
    case apple = "APPLE"
}
