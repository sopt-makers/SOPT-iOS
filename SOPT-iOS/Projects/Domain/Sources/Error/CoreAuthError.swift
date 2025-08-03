//
//  CoreAuthError.swift
//  Domain
//
//  Created by 장석우 on 1/18/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

public enum CoreAuthError: Error {
    case oAuthFail(OAuthProvider)
    case loginFail(String?)
    case signUpFail(String?)
    case changeSocialAccountFail
    case unknown(Error)
}

extension CoreAuthError {
    public var description: String {
        switch self {
        case .oAuthFail(let provider):
            "\(provider.title) 인증 시 문제가 발생했습니다."
        case .loginFail(let message):
            message ?? "로그인에 문제가 발생했습니다."
        case .signUpFail(let message):
            message ?? "회원가입에 문제가 발생했습니다."
        case .changeSocialAccountFail:
            "소셜 계정 변경에 문제가 발생했습니다."
        case .unknown(_):
            "알 수 없는 문제가 발생했습니다."
        }
    }
}
