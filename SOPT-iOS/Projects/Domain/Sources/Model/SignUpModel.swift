//
//  SignUpModel.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public struct SignUpModel: Equatable {
    public let phone: String
    public let token: String
    public let provider: OAuthProvider
    
    init(
        phone: String,
        token: String,
        provider: OAuthProvider
    ) {
        self.phone = phone
        self.token = token
        self.provider = provider
    }
}
