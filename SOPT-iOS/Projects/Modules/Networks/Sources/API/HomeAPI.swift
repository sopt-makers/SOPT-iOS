//
//  HomeAPI.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Moya
import Core

public enum HomeAPI {
    case getDescription
    case getAppServiceAccessStatus
    case getPlaygroundNewsPosts
}

extension HomeAPI: BaseAPI {
    public static var apiType: APIType = .home
    
    public var path: String {
        switch self {
        case .getDescription:
            return "/description"
        case .getAppServiceAccessStatus:
            return "/app-service"
        case .getPlaygroundNewsPosts:
            return "/posts"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDescription, .getAppServiceAccessStatus, .getPlaygroundNewsPosts:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getDescription, .getAppServiceAccessStatus, .getPlaygroundNewsPosts:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .getAppServiceAccessStatus:
            let userType = UserDefaultKeyList.Auth.getUserType()
            return userType == .visitor ? HeaderType.json.value : HeaderType.jsonWithToken.value
        default: return HeaderType.jsonWithToken.value
        }
    }
}
