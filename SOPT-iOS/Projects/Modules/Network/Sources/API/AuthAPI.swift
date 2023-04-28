//
//  AuthAPI.swift
//  Network
//
//  Created by Junho Lee on 2022/10/16.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya
import Core

public enum AuthAPI {
    case signIn(token: String)
    case reissuance
}

extension AuthAPI: BaseAPI {
    
    public static var apiType: APIType = .auth
    
    // MARK: - Header
    public var headers: [String: String]? {
        switch self {
        case .signIn, .reissuance:
            return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .signIn:
            return "playground"
        case .reissuance:
            return "refresh"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        case .reissuance:
            return .patch
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .signIn(let token):
            params["code"] = token
        case .reissuance:
            params["refreshToken"] = UserDefaultKeyList.Auth.appRefreshToken
        }
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    public var task: Task {
        switch self {
        case .signIn, .reissuance:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    public var validationType: ValidationType {
        return .none
    }
}
