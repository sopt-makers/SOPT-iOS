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
    case getFABInfo
    case getSurveyInfo
    case getPopularPosts
    case getLatestPosts
}

extension HomeAPI: BaseAPI {
    public static var apiType: APIType = .home
    
    public var path: String {
        switch self {
        case .getDescription:
            return "/description"
        case .getAppServiceAccessStatus:
            return "/app-service"
        case .getFABInfo:
            return "/floating-button"
        case .getSurveyInfo:
            return "/review-form"
        case .getPopularPosts:
            return "/posts/popular"
        case .getLatestPosts:
            return "/posts/latest"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDescription, .getAppServiceAccessStatus, .getFABInfo, .getSurveyInfo, .getPopularPosts, .getLatestPosts:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getDescription, .getAppServiceAccessStatus, .getFABInfo, .getSurveyInfo, .getPopularPosts, .getLatestPosts:
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
