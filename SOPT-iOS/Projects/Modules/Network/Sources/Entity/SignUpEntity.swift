//
//  SignUpEntity.swift
//  Network
//
//  Created by sejin on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct SignUpEntity {
    public let nickname: String
    public let email: String
    public let password: String
    
    public init(nickname: String, email: String, password: String) {
        self.nickname = nickname
        self.email = email
        self.password = password
    }
}
