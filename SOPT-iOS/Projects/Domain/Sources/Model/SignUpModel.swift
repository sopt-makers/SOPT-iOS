//
//  SignUpModel.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct SignUpModel {
    public let name: String?
    public let phone: String
    public let token: String
    public let provider: OAuthProvider
    
    init(
        name: String?,
        phone: String,
        token: String,
        provider: OAuthProvider
    ) {
        self.name = name
        self.phone = phone
        self.token = token
        self.provider = provider
    }
}
