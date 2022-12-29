//
//  UserAPI.swift
//  Network
//
//  Created by Junho Lee on 2022/12/03.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum UserAPI {
    case signUp(nickname: String, email: String, password: String)
    case signIn(email: String, password: String)
}

extension UserAPI: BaseAPI {
    
    public static var apiType: APIType = .user
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .signUp:
            return "signup"
        case .signIn:
            return "login"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .signUp, .signIn:
            return .post
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .signUp(let nickname, let email, let password):
            params["nickname"] = nickname
            params["email"] = email
            params["password"] = password
        case .signIn(let email, let password):
            params["email"] = email
            params["password"] = password
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
        case .signUp, .signIn:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
}
