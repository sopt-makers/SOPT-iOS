//
//  FirebaseAPI.swift
//  Network
//
//  Created by sejin on 2023/01/18.
//  Copyright © 2023 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

import Core

import Alamofire
import Moya

public enum FirebaseAPI {
    case getAppNotice
}

extension FirebaseAPI: BaseAPI {
    
    public static var apiType: APIType = .firebase
    
    // MARK: - Header
    
    public var headers: [String: String]? {
        switch self {
        case .getAppNotice:
            return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    
    public var path: String {
        switch self {
        case .getAppNotice:
            return ""
        }
    }
    
    // MARK: - Method
    
    public var method: Moya.Method {
        switch self {
        default: return .get
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
