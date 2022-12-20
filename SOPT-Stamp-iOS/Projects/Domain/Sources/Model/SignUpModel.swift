//
//  SignUpModel.swift
//  Domain
//
//  Created by sejin on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct SignUpModel {

    public let nickname, email, password: String
    public let osType = "iOS"
    public let clientToken: String? = nil

    public init(nickname: String, email: String, password: String) {
        self.nickname = nickname
        self.email = email
        self.password = password
    }
}
