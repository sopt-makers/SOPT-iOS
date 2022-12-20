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
}

extension AuthAPI: BaseAPI {
    
    public static var apiType: APIType = .auth
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .getNicknameAvailable:
            return ""
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .getNicknameAvailable:
            return .get
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .getNicknameAvailable(_):
            break
        }
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .getNicknameAvailable:
            return JSONEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    public var task: Task {
        switch self {
        case .getNicknameAvailable(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
}
