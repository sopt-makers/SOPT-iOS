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
    case getNicknameAvailable(nickname: String)
    case getEmailAvailable(email: String)
}

extension AuthAPI: BaseAPI {
    
    public static var apiType: APIType = .auth
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .getNicknameAvailable:
            return ""
        case .getEmailAvailable:
            return ""
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .getNicknameAvailable:
            return .get
        case .getEmailAvailable:
            return .get
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .getNicknameAvailable, .getEmailAvailable:
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
        case .getNicknameAvailable(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        case .getEmailAvailable(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
}
