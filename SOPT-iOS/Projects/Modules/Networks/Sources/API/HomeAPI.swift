//
//  HomeAPI.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya
import Core

public enum HomeAPI {
    case getDescription
    case getGroupAll
    case getCoffeeChat
}

extension HomeAPI: BaseAPI {
    public static var apiType: APIType = .home
    
    public var path: String {
        switch self {
        case .getDescription:
            return "/description"
        case .getGroupAll:
            return "/meeting/all"
        case .getCoffeeChat:
            return "/coffeechat"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDescription, .getGroupAll, .getCoffeeChat:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getDescription, .getCoffeeChat:
            return .requestPlain
        case .getGroupAll:
            return .requestParameters(parameters: ["page": 1, "take": 10, "category": "행사,세미나"], encoding: URLEncoding.queryString)
        }
    }
}
