//
//  CoreAuthAPI.swift
//  Networks
//
//  Created by 장석우 on 12/30/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Moya
import Core

public enum CoreAuthAPI {
    case sendVerifyCode(phone: )
    case verfiyCode(entity: )
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
        case .sendVerifyCode(phone: let phone):
            <#code#>
        case .verfiyCode(entity: let entity):
            <#code#>
        case .signUp:
            <#code#>
        case .signIn:
            <#code#>
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .getSocialAccount:
            return .get
        case .changeSocialAccount:
            return .patch
        }
    }
    
    
    public var task: Task {
        switch self {
        case let .getSocialAccount(phone):
            return .requestParameters(parameters: ["phone": phone], encoding: URLEncoding.queryString)
        case let .changeSocialAccount(entity):
            return .requestJSONEncodable(entity)
        }
    }
    
    public var validationType: ValidationType {
        return .none
    }
}


