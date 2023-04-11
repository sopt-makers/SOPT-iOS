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

public enum AuthAPI {
    case withdrawal
    case signIn(token: String)
}

extension AuthAPI: BaseAPI {
    
    public static var apiType: APIType = .auth
    
    // MARK: - Header
    public var headers: [String: String]? {
        switch self {
        case .withdrawal:
            return HeaderType.jsonWithToken.value
        default: return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .withdrawal:
            return "withdraw"
        case .signIn:
            return "playground"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .withdrawal:
            return .delete
        case .signIn:
            return .post
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .signIn(let token):
            params["code"] = token
        default:
            break
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
        case .signIn:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
}
