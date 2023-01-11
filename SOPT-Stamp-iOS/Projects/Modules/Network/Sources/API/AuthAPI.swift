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
    case changePassword(password: String, userId: Int)
    case changeNickname(userId: Int, nickname: String)
    case withdrawal(userId: Int)
}

extension AuthAPI: BaseAPI {
    
    public static var apiType: APIType = .auth
    
    // MARK: - Header
    public var headers: [String: String]? {
        switch self {
        case .changePassword(_, let userId), .changeNickname(let userId, _), .withdrawal(let userId):
            return HeaderType.userId(userId: userId).value
        default: return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .getNicknameAvailable, .getEmailAvailable:
            return ""
        case .changePassword:
            return "password"
        case .changeNickname:
            return "nickname"
        case .withdrawal:
            return "withdraw"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .getNicknameAvailable, .getEmailAvailable:
            return .get
        case .changePassword, .changeNickname:
            return .patch
        case .withdrawal:
            return .delete
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .changePassword(let password, _):
            params["password"] = password
        case .changeNickname(_, let nickname):
            params["nickname"] = nickname
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
        case .getNicknameAvailable(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        case .getEmailAvailable(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
        case .changePassword, .changeNickname:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
}
