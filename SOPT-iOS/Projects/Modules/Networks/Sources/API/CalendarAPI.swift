//
//  CalendarAPI.swift
//  Networks
//
//  Created by Jae Hyun Lee on 1/14/25.
//  Copyright © 2025 SOPT-iOS. All rights reserved.
//

import Foundation

import Moya

public enum CalendarAPI {
    case getRecentSchedule
    case getCalendarDetail
}

extension CalendarAPI: BaseAPI {
    public static var apiType: APIType = .calendar
    
    public var path: String {
        switch self {
        case .getRecentSchedule:
            return "/recent"
        case .getCalendarDetail:
            return "/all"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getRecentSchedule, .getCalendarDetail:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getRecentSchedule, .getCalendarDetail:
            return .requestPlain
        }
    }
}
