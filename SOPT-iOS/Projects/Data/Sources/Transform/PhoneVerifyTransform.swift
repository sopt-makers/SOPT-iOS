//
//  PhoneVerifyTransform.swift
//  Data
//
//  Created by 장석우 on 1/23/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Domain
import Networks

extension PhoneVerifyType {
    func toData() -> VerifyEntityType {
        switch self {
        case .changePhoneNumber: return .changePhoneNumber
        case .changeSocialAccount: return .changeSocialAccount
        case .register: return .register
        case .searchSocialAccount: return .searchSocialAccount
        }
    }
}

extension PhoneSendModel {
    func toData() -> SendVerificationCodeRequestEntity {
        .init(name: name, phone: phone, type: type.toData())
    }
}


extension PhoneVerifyModel {
    func toData() -> VerifyCodeRequestEntity {
        .init(name: name, phone: phone, type: type.toData(), code: code)
    }
}
