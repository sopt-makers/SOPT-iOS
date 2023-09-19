//
//  DescriptionAPI.swift
//  Network
//
//  Created by sejin on 2023/09/19.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Foundation

import Moya
import Core

public enum DescriptionAPI {
    case getMainViewDescription
}

extension DescriptionAPI: BaseAPI {
    public static var apiType: APIType = .description
    
    public var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }
}
