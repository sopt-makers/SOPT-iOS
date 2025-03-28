//
//  SignUpPhoneVerificationModel.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public enum PhoneVerifyType {
    case register  // 회원가입
    case change    // 소설계정재설정
    case search    // 계정 찾기
}

public struct PhoneSendModel {
    public let name: String?
    public let phone: String
    public let type: PhoneVerifyType
    
    public init(name: String?, phone: String, type: PhoneVerifyType) {
        self.name = name
        self.phone = phone
        self.type = type
    }
}

public struct PhoneVerifyModel {
    public let name: String?
    public let phone: String
    public let code: String
    public let type: PhoneVerifyType
    
    public init(name: String?, phone: String, code: String, type: PhoneVerifyType) {
        self.name = name
        self.phone = phone
        self.code = code
        self.type = type
    }
}
