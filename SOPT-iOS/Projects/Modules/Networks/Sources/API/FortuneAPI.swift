//
//  FortuneAPI.swift
//  Networks
//
//  Created by Jae Hyun Lee on 9/23/24.
//  Copyright © 2024 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya
import Core

public enum FortuneAPI {
    case getTodaysFortuneCard
}

extension FortuneAPI: BaseAPI {
    public static var apiType: APIType = .fortune
    
    public var path: String {
        switch self {
        case .getTodaysFortuneCard:
            return "/card/today"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getTodaysFortuneCard:
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
