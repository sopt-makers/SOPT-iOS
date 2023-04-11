//
//  AttendanceAPI.swift
//  Network
//
//  Created by devxsby on 2023/04/11.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public enum AttendanceAPI {
    case lecture
    case score
    case total
}

extension AttendanceAPI: BaseAPI {
    
    public static var apiType: APIType = .attendance
    
    // MARK: - Header
    public var headers: [String: String]? {
        switch self {
        case .lecture, .score, .total:
            return HeaderType.authorization(accessToken: "accessToken").value
        default: return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .lecture:
            return "lecture"
        case .score:
            return "score"
        case .total:
            return "total"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .lecture, .score, .total:
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
