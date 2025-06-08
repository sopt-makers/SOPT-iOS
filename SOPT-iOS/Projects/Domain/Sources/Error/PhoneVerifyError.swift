//
//  SignUpError.swift
//  Domain
//
//  Created by 장석우 on 12/20/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

public enum PhoneVerifyError: Error {
    case userNotFound
    case invalidRequest
    case alreadyExist
    case invalidVerifyCode //인증 내역은 유효하나 제출한 “인증 번호”가 일치하지 않을 경우
    case timeout // 시간 초과
    case unknown(Error)
}
