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
import Core

public enum APIType {
    case attendance
    case auth
    case mission
    case rank
    case stamp
    case user
    case firebase
    case config
}

public protocol BaseAPI: TargetType {
    static var apiType: APIType { get set }
}

extension BaseAPI {
    public var baseURL: URL {
        var base = Config.Network.baseURL
        let operationBaseURL = Config.Network.operationBaseURL
        
        switch Self.apiType {
        case .attendance:
            base = operationBaseURL
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
        case .config:
            base += "/config"
        }
        
        guard let url = URL(string: base) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    public var headers: [String: String]? {
        return HeaderType.jsonWithToken.value
    }
}

public enum HeaderType {
    case json
    case jsonWithToken
    case multipartWithToken
    
    public var value: [String: String] {
        switch self {
        case .json:
            return ["Content-Type": "application/json"]
        case .jsonWithToken:
            return ["Content-Type": "application/json",
                    "Authorization": UserDefaultKeyList.Auth.appAccessToken ?? "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzb3B0LW1ha2VycyIsImlhdCI6MTY4MTU0NDk2Mywic3ViIjoiMSIsImV4cCI6MTY4MTYzMTM2MywiaWQiOjEsInBsYXlncm91bmRJZCI6MjIsInJvbGVzIjoiVVNFUiJ9.aMr_m2QzoWKoUwnAHntQMCwHppk0UjubfsILem9NI-I"]
        case .multipartWithToken:
            return ["Content-Type": "multipart/form-data",
                    "Authorization": UserDefaultKeyList.Auth.appAccessToken ?? "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzb3B0LW1ha2VycyIsImlhdCI6MTY4MTIwMTkwNywic3ViIjoiMiIsImV4cCI6MTY4MTI4ODMwNywiaWQiOjIsInJvbGVzIjoiVVNFUiJ9.X-b45sMMQeUiyDnZEHdKEowor_g0wH_YlugeuAhWqYk"]
        }
    }
}
