//
//  AppjamRankAPI.swift
//  Networks
//
//  Created by 강윤서 on 1/5/26.
//  Copyright © 2026 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum AppjamRankAPI {
    case recent(size: Int)
    case today(size: Int)
}

extension AppjamRankAPI: BaseAPI {
    
    public static var apiType: APIType = .appjamRank
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .recent:
            return "/recent"
        case .today:
            return "/today"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        default: return .get
        }
    }
    
    // MARK: - Parameters
    private var queryParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case .recent(let size):
            params["size"] = size
        case .today(let size):
            params["size"] = size
        }
        return params
    }

    private var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    public var task: Task {
        switch self {
        case .recent, .today:
            return .requestParameters(parameters: queryParameters ?? [:], encoding: parameterEncoding)
        }
    }
}
