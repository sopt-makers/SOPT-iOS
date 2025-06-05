//
//  CoreAuthAPI.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Moya

public enum CoreAuthAPI {
    case sendVerifyCode(dto: SendVerificationCodeRequestEntity)
    case verfiyCode(dto: VerifyCodeRequestEntity)
    case signUp(dto: CoreSignUpRequestEntity)
    case login(dto: CoreLoginRequestEntity)
    case changeSocialAccount(dto: CoreSignUpRequestEntity)
}

extension CoreAuthAPI: BaseAPI {
    
    public static var apiType: APIType = .coreAuth
    
    // MARK: - Header
    public var headers: [String: String]? {
        switch self {
        default:
            return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .sendVerifyCode:
            return "/phone"
        case .verfiyCode:
            return "/verify/phone"
        case .signUp:
            return "/signup"
        case .login:
            return "/login/app"
        case .changeSocialAccount:
            return "/accounts"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .sendVerifyCode:
            return .post
        case .verfiyCode:
            return .post
        case .signUp:
            return .post
        case .login:
            return .post
        case .changeSocialAccount:
            return .patch
        }
    }
    
    
    public var task: Task {
        switch self {
        case .sendVerifyCode(let dto):
            return .requestJSONEncodable(dto)
        case .verfiyCode(let dto):
            return .requestJSONEncodable(dto)
        case .signUp(let dto):
            return .requestJSONEncodable(dto)
        case .login(let dto):
            return .requestJSONEncodable(dto)
        case .changeSocialAccount(dto: let dto):
            return .requestJSONEncodable(dto)
        }
    }
    
    public var validationType: ValidationType {
        return .none
    }
}


