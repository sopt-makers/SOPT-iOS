//
//  SignUpPhoneVerificationModel.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public enum PhoneVerifyType: String {
    case register = "REGISTER" // 회원가입
    case change = "CHANGE"     // 소설계정재설정
    case search = "SEARCH"     // 계정 찾기
}

public struct PhoneSendModel {
    let name: String?
    let phone: String
    let type: PhoneVerifyType
}

public struct PhoneVerifyModel {
    let name: String?
    let phone: String
    let code: String
    let type: PhoneVerifyType
}
