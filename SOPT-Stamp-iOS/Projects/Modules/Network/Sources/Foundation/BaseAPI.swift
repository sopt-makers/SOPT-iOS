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
    case notice
    case auth
    case alert
    case user
}

public protocol BaseAPI: TargetType {
    static var apiType: APIType { get set }
}

extension BaseAPI {
    public var baseURL: URL {
        var base = Config.Network.baseURL
        
        switch Self.apiType {
        case .alert:
            base += "/alert"
        case .notice:
            base += "/notice"
        case .auth:
            base += "/auth"
        case .user:
            base += "/user"
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
