//
//  ReissueAPI.swift
//  Networks
//
//  Created by 장석우 on 7/11/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Core

import Alamofire
import Moya

//MARK: - ReissueAPI
public enum ReissueAPI {
    case reissue(AuthTokens)
}

extension ReissueAPI: BaseAPI {
    public static var apiType: APIType = .coreAuth
    
    public var path: String { "/refresh/app"}
    
    public var method: Moya.Method { .post }
    
    public var task: Moya.Task {
        switch self {
        case .reissue(let token):
                .requestJSONEncodable(token)
        }
    }
}

//MARK: - LegacyReissueAPI

public enum LegacyReissueAPI {
    case reissuance(refreshToken: String)
}

extension LegacyReissueAPI: BaseAPI {
    
    public static var apiType: APIType = .auth
    
    // MARK: - Header
    public var headers: [String: String]? {
        switch self {
        case .reissuance:
            return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .reissuance:
            return "refresh"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .reissuance:
            return .patch
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .reissuance(let refreshToken):
            params["refreshToken"] = refreshToken
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
        case .reissuance:
            return .requestParameters(parameters: bodyParameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    public var validationType: ValidationType {
        return .none
    }
}
