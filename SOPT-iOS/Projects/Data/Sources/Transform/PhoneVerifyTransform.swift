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
        case .change: return .change
        case .register: return .register
        case .search: return .search
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
