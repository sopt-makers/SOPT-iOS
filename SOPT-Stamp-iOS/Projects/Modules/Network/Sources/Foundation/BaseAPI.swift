//
//  BaseAPI.swift
//  Network
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Alamofire
import Moya
import Foundation

public enum APIType {
    case auth
    case mission
    case rank
    case stamp
    case user
    case firebase
}

public protocol BaseAPI: TargetType {
    static var apiType: APIType { get set }
}

extension BaseAPI {
    public var baseURL: URL {
        var base = Config.Network.baseURL
        
        switch Self.apiType {
        case .auth:
            base += "/auth"
        case .mission:
            base += "/mission"
        case .rank:
            base += "/rank"
        case .stamp:
            base += "/stamp"
        case .user:
            base += "/user"
        case .firebase:
            base += "/firebase"
        }
        
        guard let url = URL(string: base) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

public enum HeaderType {
    case json
    case jsonUserId(userId: Int)
    case userId(userId: Int)
    case multipart(userId: Int)
    
    public var value: [String: String] {
        switch self {
        case .json:
            return ["Content-Type": "application/json"]
        case .jsonUserId(let userId):
            return ["Content-Type": "application/json",
                    "userId": String(userId)]
        case .userId(let userId):
            return ["userId": String(userId)]
        case .multipart(let userId):
            return ["Content-Type": "multipart/form-data",
                    "userId": String(userId)]
        }
    }
}
