//
//  CoreAuthAPI.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Moya

public enum CoreAuthAPI {
    case sendVerifyCode(dto: SendVerificationCodeEntity)
    case verfiyCode(dto: VerifyCodeEntity)
    case signUp
    case signIn
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
            return "signup"
        case .signIn:
            return "/login/app"
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
        case .signIn:
            return .post
        }
    }
    
    
    public var task: Task {
        switch self {
        case let .sendVerifyCode(dto):
            return .requestJSONEncodable(dto)
        case let .verfiyCode(dto):
            return .requestJSONEncodable(dto)
        case .signUp:
            return .requestPlain
        case .signIn:
            return .requestPlain
        }
    }
    
    public var validationType: ValidationType {
        return .none
    }
}


