//
//  SocialAPI.swift
//  Networks
//
//  Created by 장석우 on 12/28/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya
import Core

public enum SocialAPI {
    case getSocialAccount(phone: String)
    case changeSocialAccount(entity: ChangeSocialAccountEntity)
}

extension SocialAPI: BaseAPI {
    
    public static var apiType: APIType = .social
    
    // MARK: - Header
    public var headers: [String: String]? {
        switch self {
        default:
            return HeaderType.json.value
        }
    }
    
    // MARK: - Path
    public var path: String {
        switch self {
        case .getSocialAccount:
            return "/accounts/platform"
        case .changeSocialAccount:
            return "/accounts"
        }
    }
    
    // MARK: - Method
    public var method: Moya.Method {
        switch self {
        case .getSocialAccount:
            return .get
        case .changeSocialAccount:
            return .patch
        }
    }
    
    
    public var task: Task {
        switch self {
        case let .getSocialAccount(phone):
            return .requestParameters(parameters: ["phone": phone], encoding: URLEncoding.queryString)
        case let .changeSocialAccount(entity):
            return .requestJSONEncodable(entity)
        }
    }
    
    public var validationType: ValidationType {
        return .none
    }
}

