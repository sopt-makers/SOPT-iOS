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
    case sample(provider: String)
}

extension AuthAPI: BaseAPI {
    
    public static var apiType: APIType = .auth
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .sample:
            return ""
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .sample:
            return .post
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .sample(let provider):
            params["platform"] = provider
        }
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        case .sample:
            return URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
        default:
            return JSONEncoding.default
        }
    }
    
    public var task: Task {
        switch self {
        case .sample:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        default:
            return .requestPlain
        }
    }
}
