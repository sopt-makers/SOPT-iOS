//
//  CalendarAPI.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Alamofire
import Moya
import Core

public enum CalendarAPI {
    case getRecentSchedule
}

extension CalendarAPI: BaseAPI {
    public static var apiType: APIType = .calendar
    
    public var path: String {
        switch self {
        case .getRecentSchedule:
            return "/recent"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getRecentSchedule:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getRecentSchedule:
            return .requestPlain
        }
    }
}
