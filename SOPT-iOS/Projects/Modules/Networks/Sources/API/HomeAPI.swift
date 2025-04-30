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
    case getInsightPosts
    case getGroupAll
    case getCoffeeChat
    case getEmployment
}

extension HomeAPI: BaseAPI {
    public static var apiType: APIType = .home
    
    public var path: String {
        switch self {
        case .getDescription:
            return "/description"
        case .getAppServiceAccessStatus:
            return "/app-service"
        case .getInsightPosts:
            return "/posts"
        case .getGroupAll:
            return "/meeting/all"
        case .getCoffeeChat:
            return "/coffeechat"
        case .getEmployment:
            return "/employments"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDescription, .getAppServiceAccessStatus, .getInsightPosts, .getGroupAll, .getCoffeeChat, .getEmployment:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getDescription, .getAppServiceAccessStatus, .getInsightPosts, .getCoffeeChat, .getEmployment:
            return .requestPlain
        case .getGroupAll:
            return .requestParameters(parameters: ["page": 1, "take": 10, "category": "행사,세미나"], encoding: URLEncoding.queryString)
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
