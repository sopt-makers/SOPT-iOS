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
    case fetchUser
}

extension UserAPI: BaseAPI {
    
    public static var apiType: APIType = .user
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .fetchUser:
            return ""
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .fetchUser:
            return .get
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        default: break
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
        default:
            return .requestPlain
        }
    }
}
