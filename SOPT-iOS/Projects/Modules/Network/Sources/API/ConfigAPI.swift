//
//  ConfigAPI.swift
//  Network
//
//  Created by sejin on 2023/04/15.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum ConfigAPI {
    case getServiceAvailability
}

extension ConfigAPI: BaseAPI {
    public static var apiType: APIType = .config
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .getServiceAvailability:
            return "/availability"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .getServiceAvailability:
            return .get
        }
    }
    
    // MARK: - Parameters
    private var bodyParameters: Parameters? {
        var params: Parameters = [:]
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
